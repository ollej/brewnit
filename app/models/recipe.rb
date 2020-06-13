class Recipe < ApplicationRecord
  include MediaParentConcern
  include SearchCop
  include SanitizerConcern
  include PushoverConcern

  media_attribute :media_main

  search_scope :search do
    attributes primary: [:name, :description, :style_name, :brewer, :equipment]
    attributes :name, :brewer, :abv, :ibu, :og, :fg, :color, :batch_size, :style_code,
      :style_guide, :style_name, :created_at, :brewer, :equipment, :complete, :public
    attributes owner: 'user.name'
    attributes event: 'events.name'
    attributes event_id: 'events.id'
    attributes medal: 'placements.medal'
    options :primary, type: :fulltext, default: true, dictionary: 'swedish_snowball'
    options :owner, type: :fulltext, dictionary: 'swedish_snowball'
    options :style_name, type: :fulltext, dictionary: 'swedish_snowball'
    options :event, type: :fulltext, dictionary: 'swedish_snowball'
  end

  after_create do |recipe|
    recipe.commontator_thread.subscribe(recipe.user)
  end

  belongs_to :user, counter_cache: true
  belongs_to :media_main, class_name: 'Medium', optional: true
  has_many :media, as: :parent, dependent: :destroy
  has_and_belongs_to_many :events
  has_many :placements, dependent: :destroy
  has_many :registrations, dependent: :destroy, class_name: 'EventRegistration'
  has_one :detail, dependent: :destroy, class_name: 'RecipeDetail'

  accepts_nested_attributes_for :media, reject_if: lambda { |r| r['media'].nil? }

  validates :beerxml, beerxml: true, allow_blank: true

  acts_as_commontable
  acts_as_votable

  sanitized_fields :description

  default_scope { where(public: true) }
  scope :completed, -> { where(complete: true) }
  scope :for_user, -> (user) {
    unscoped.where('recipes.user_id = ? OR (recipes.public = true AND recipes.complete = true)', user.id)
  }
  scope :by_user, -> (user) { where(user: user) }
  scope :by_event, -> (event) { joins(:events).where(events: { id: event.id }) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :latest, -> { completed.limit(10).ordered }
  scope :with_details, -> (ingredient) { includes(detail: [ingredient]) }
  scope :with_all_details, -> {
    includes(detail: [:fermentables, :hops, :miscs, :yeasts, :style, :mash_steps])
  }

  def owned_by?(u)
    self.user == u
  end

  def owner_name
    user&.name.presence || '[N/A]'
  end

  def brewer_name
    user&.brewery.presence || brewer.presence || owner_name
  end

  def equipment
    user&.equipment
  end

  def display_desc
    if description.present?
      Rails::Html::FullSanitizer.new.sanitize(description)
    else
      style_name
    end
  end

  def main_image(size = :medium_thumbnail)
    if media_main.present?
      media_main.file.url(size)
    elsif user.present?
      if user.media_brewery.present?
        user.media_brewery.file.url(size)
      else
        user.avatar_image(size)
      end
    end
  end

  def placement
    placements.sort_by { |p| p.medal }.last
  end

  def comments
    commontator_thread.comments.size
  end

  def registration_message_for(event)
    registrations.by_event(event).first&.message
  end

  def pushover_translation
    {
      recipe_name: name,
      brewer_name: brewer_name,
      style_name: style_name.presence || I18n.t(:'common.beer')
    }
  end

  def pushover_values_create
    {
      title: I18n.t(:'common.notification.recipe.created.title', pushover_translation),
      message: I18n.t(:'common.notification.recipe.created.message', pushover_translation),
      url: Rails.application.routes.url_helpers.recipe_url(self),
      user: pushover_user
    }
  end

  def pushover_values_destroy
    {
      title: I18n.t(:'common.notification.recipe.destroyed.title', pushover_translation),
      message: I18n.t(:'common.notification.recipe.destroyed.message', pushover_translation),
      sound: :falling,
      user: pushover_user
    }
  end

  def pushover_user
    if public?
      Rails.application.secrets.pushover_group_recipe
    else
      Rails.application.secrets.pushover_user
    end
  end

  def add_event(event:, user: nil, placement: {}, registration: {})
    event = Event.find(event) unless event.kind_of? Event
    raise RegistrationsClosed if event.registration_closed?
    transaction do
      events << event unless events.include?(event)
      add_placement(event: event, user: user, placement: placement) if placement[:medal].present?
    end
    return event
  end

  def add_placement(event:, user:, placement:)
    Rails.logger.debug { "add_placement #{event.inspect} #{user.inspect} #{placement.inspect}" }
    if !event.official? || user.can_modify?(event)
      Placement.create!(event: event, user: user, recipe: self, medal: placement[:medal], category: placement[:category])
    end
  end

  def remove_event(event)
    transaction do
      events.delete(event)
      placements.by_event(event).destroy_all
      registrations.by_event(event).destroy_all
    end
  end

  def hop_data(hop)
    {
      name: hop.name,
      size: hop.amount,
      time: hop.time,
      ibu: hop.ibu,
      aau: hop.aau,
      mgl_alpha: hop.mgl_added_alpha_acids,
      grams_per_liter: hop.amount / batch_size,
      tooltip: hop_info(hop)
    }
  end

  def hop_info(hop)
    "#{hop.formatted_amount} #{I18n.t(:'beerxml.grams')} #{hop.name} @ #{hop.formatted_time} #{I18n.t("beerxml.#{hop.time_unit}", default: hop.time_unit)}"
  end

  def hop_additions
    hops = {}
    hops_sorted.map do |h|
      if hops[h.time]
        hops[h.time][:children] << hop_data(h)
      else
        hops[h.time] = { name: hop_addition_name(h), children: [hop_data(h)] }
      end
    end
  end

  def hops_sorted
    beerxml_details.hops.sort_by { |hop| hop.time }
  end

  def boil_hops
    hops_sorted.select { |hop| hop.use == 'Boil' }
  end

  def whirlpool_hops
    hops_sorted.select { |hop| hop.use == 'Aroma' }
  end

  def hop_steps
    boil_hops.map do |step|
      {
        name: hop_addition_name(step),
        description: hop_info(step),
        addition_time: step.time.to_i,
      }
    end
  end

  def misc_info(misc)
    "#{misc.formatted_amount} #{I18n.t("beerxml.#{misc.unit}", default: 'grams')} #{misc.name} @ #{misc.formatted_time} #{I18n.t("beerxml.#{misc.time_unit}", default: misc.time_unit)}"
  end

  def miscs_sorted
    beerxml_details.miscs.sort_by { |misc| misc.time }
  end

  def boil_miscs
    miscs_sorted.select { |misc| misc.use == 'Boil' }
  end

  def misc_steps
    boil_miscs.map do |step|
      {
        name: step.type,
        description: misc_info(step),
        addition_time: step.time.to_i,
      }
    end
  end

  def calculate_step_times(steps)
    step_times = 0
    steps.map do |step|
      step_time = step[:addition_time] - step_times
      step_times += step_time
      step[:time] = step_time * 60
      step
    end

    steps
  end

  def add_boil_step(steps)
    highest_step_time = steps.map { |step| step[:addition_time] }.max
    boil_time = beerxml_details.boil_time - highest_step_time
    #Rails.logger.debug { "highest_step_time: #{highest_step_time} boil_time: #{boil_time} total_boil_time: #{beerxml_details.boil_time}" }
    if highest_step_time < beerxml_details.boil_time
      steps << {
        name: I18n.t(:'beerxml.Boil'),
        description: I18n.t(:'beerxml.boil_time', boil_time: boil_time),
        addition_time: beerxml_details.boil_time.to_i
      }
    end
    steps
  end

  def merge_steps(steps)
    additions = {}
    steps.sort_by! { |step| step[:addition_time] }
    steps.each do |step|
      if additions[step[:addition_time]]
        description = [step[:description], additions[step[:addition_time]][:description]].join("\n")
        additions[step[:addition_time]][:description] = description
      else
        additions[step[:addition_time]] = step
      end
    end
    additions.values
  end

  def boil_step_list
    steps = hop_steps + misc_steps
    steps = merge_steps(steps)
    steps = add_boil_step(steps)
    steps = calculate_step_times(steps)

    # TODO: Add whirlpool additions

    steps.reverse
  end

  def mash_step_list
    steps = []
    beerxml_details.mash.steps.each do |step|
      steps.push({
        name: step.name,
        description: "Raise to #{step.step_temp}°C",
        time: step.ramp_time * 60,
      })
      steps.push({
        name: step.name,
        description: "Hold at #{step.step_temp}°C for #{step.step_time} min",
        time: step.step_time * 60,
      })
    end
    steps
  end

  def likes_list
    get_likes.map(&:voter).map(&:display_name).to_sentence
  end

  def self.recipe_options(scope)
    scope.map { |recipe| [recipe.name, recipe.id] }
  end

  def self.styles
    self.distinct.pluck(:style_name).map(&:capitalize).uniq.sort
  end

  def self.equipments
    self.distinct.pluck(:equipment).reject { |r| r.empty? }.map(&:capitalize).uniq.sort
  end
end
