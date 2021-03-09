class User < ApplicationRecord
  include MediaParentConcern
  include SearchCop
  include SanitizerConcern
  include PushoverConcern

  media_attribute :media_avatar, :media_brewery

  search_scope :search do
    attributes primary: [:name, :presentation, :equipment, :brewery, :twitter]
    attributes :name, :brewer, :equipment
    options :primary, type: :fulltext, default: true, dictionary: 'swedish_snowball'
    options :brewery, type: :fulltext, default: false, dictionary: 'swedish_snowball'
    options :equipment, type: :fulltext, default: false, dictionary: 'swedish_snowball'
  end

  before_validation :cleanup_fields
  has_many :recipes, dependent: :destroy
  has_many :media, as: :parent, dependent: :destroy
  belongs_to :media_avatar, class_name: 'Medium', optional: true
  belongs_to :media_brewery, class_name: 'Medium', optional: true
  accepts_nested_attributes_for :media, :reject_if => lambda { |r| r['media'].nil? }

  validates :name, presence: true
  validates :url, url: true, allow_blank: true

  acts_as_commontator
  acts_as_voter

  sanitized_fields :presentation

  # Unused: :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable,
         :registerable, :timeoutable, :confirmable, :omniauthable, omniauth_providers: [:google]

  scope :by_query, lambda { |query, col = :name|
    where arel_table[col].matches("%#{query}%")
  }
  scope :ordered, -> { order("users.name ASC, brewery ASC") }
  scope :confirmed, -> { where('confirmed_at IS NOT NULL') }
  scope :unconfirmed, -> { where( 'confirmed_at is NULL AND confirmation_sent_at < ?', Time.now - Devise.confirm_within) }
  scope :latest, -> { confirmed.limit(10).order('created_at desc') }
  scope :has_recipes, -> {
    select('users.*, (users.recipes_count > 0) as has_recipes')
      .order('has_recipes DESC')
  }

  def display_name(default = nil)
    name_or_brewery || default.presence || I18n.t(:'common.unknown_name')
  end

  def name_or_brewery
    name.presence || brewery.presence
  end

  def brewery_or_name
    brewery.presence || name.presence
  end

  def admin?
    admin
  end

  def owned_by?(user)
    self == user
  end

  def has_avatar?
    media_avatar.present?
  end

  def avatar_image(size = :medium_thumbnail)
    if has_avatar?
      media_avatar.file.url(size)
    else
      nil
    end
  end

  def default_avatar(options = {})
    SvgAvatar.for_user(
      username: "#{name} #{brewery}".strip,
      email: email.presence || name_or_brewery,
      options: options.merge(
        fontsize: (options[:height] || 64) / 2
      ))
  end

  def can_modify?(resource)
    return false if resource.nil?
    return true if self == resource
    return true if resource.owned_by?(self)
    return true if admin?
    return false
  end

  def can_show?(resource)
    resource.public? || can_modify?(resource)
  end

  def cleanup_fields
    if url.present? && !url.start_with?('http')
      self.url = "http://#{url.strip}"
    end
    if twitter.present? && !twitter.start_with?('@')
      self.twitter = "@#{twitter.strip}"
    end
  end

  def user_info
    attributes
      .slice('brewery', 'native_notifications')
      .merge(
        name: display_name,
        server_notifications: pushover_user_key.present?
      )
  end

  def pushover_translation
    {
      name: name.blank? ? email : name,
      email: email,
    }
  end

  def pushover_values_create
    {
      title: I18n.t(:'common.notification.user.created.title', **pushover_translation),
      message: I18n.t(:'common.notification.user.created.message', **pushover_translation),
      sound: :bugle,
      url: Rails.application.routes.url_helpers.user_url(self)
    }
  end

  def pushover_values_destroy
    {
      title: I18n.t(:'common.notification.user.destroyed.title', **pushover_translation),
      message: I18n.t(:'common.notification.user.destroyed.message', **pushover_translation),
      sound: :siren,
    }
  end

  def self.from_omniauth(auth_hash, honeypot)
    user = User.find_by(uid: auth_hash.uid, provider: auth_hash.provider) ||
      User.find_by(email: auth_hash.info.email) ||
      User.create!(self.omniauth_user_data(auth_hash, honeypot))
    if user.uid.blank?
      user.update(
        uid: auth_hash.uid,
        provider: auth_hash.provider
      )
    end
    if auth_hash.info.image.present? && !user.has_avatar?
      user.create_medium(auth_hash.info.image, :avatar)
    end
    user
  end

  def self.search_name(query)
    if query.present?
      self.search(or: [{ query: query }, { name: query }])
    else
      all
    end
  end

  def self.omniauth_user_data(auth_hash, honeypot)
    {
      uid: auth_hash.uid,
      email: auth_hash.info.email,
      provider: auth_hash.provider,
      name: auth_hash.info.name,
      password: Devise.friendly_token[0,20],
      registration_data: self.registration_data_hash(auth_hash.provider, auth_hash.info.email, honeypot)
    }
  end

  def self.registration_data_hash(provider, email, honeypot)
    {
      provider: provider,
      email: email,
      ip_address: honeypot.ip_address,
      score: honeypot.score,
      safe: honeypot.safe?,
      offences: honeypot.offenses,
    }
  end
end
