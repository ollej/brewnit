class User < ApplicationRecord
  include MediaParentConcern
  include SearchCop
  include SanitizerConcern
  include PushoverConcern

  search_scope :search do
    attributes primary: [:name, :presentation, :equipment, :brewery, :twitter]
    attributes :brewer, :equipment
    options :primary, type: :fulltext, default: true, dictionary: 'swedish_snowball'
    options :brewery, type: :fulltext, default: false, dictionary: 'swedish_snowball'
    options :equipment, type: :fulltext, default: false, dictionary: 'swedish_snowball'
  end

  before_validation :cleanup_fields
  has_many :recipes, dependent: :destroy
  has_many :media, as: :parent, dependent: :destroy
  belongs_to :media_avatar, class_name: 'Medium'
  belongs_to :media_brewery, class_name: 'Medium'
  accepts_nested_attributes_for :media, :reject_if => lambda { |r| r['media'].nil? }

  validates :name, presence: true
  validates :url, url: true, allow_blank: true
  validates_format_of :avatar,
    with: %r{\Ahttps?://.+/.+\.(gif|jpe?g|png)\z}i,
    message: I18n.t(:'activerecord.errors.models.user.attributes.avatar.format'),
    allow_blank: true

  acts_as_commontator
  acts_as_voter

  sanitized_fields :presentation

  # Unused: :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable,
         :registerable, :timeoutable, :confirmable, :omniauthable, omniauth_providers: [:google]

  scope :by_query, lambda { |query, col = :name|
    where arel_table[col].matches("%#{query}%")
  }
  scope :ordered, -> { order("name = '', name ASC, brewery ASC") }
  scope :confirmed, -> { where('confirmed_at IS NOT NULL') }
  scope :unconfirmed, -> { where( 'confirmed_at is NULL AND confirmation_sent_at < ?', Time.now - Devise.confirm_within) }
  scope :latest, -> { confirmed.limit(10).order('created_at desc') }

  def display_name
    if name.present?
      name
    elsif brewery.present?
      brewery
    else
      I18n.t(:'common.unknown_name')
    end
  end

  def admin?
    admin
  end

  def owned_by?(user)
    self == user
  end

  def avatar_image(size = :medium_thumbnail)
    if media_avatar.present?
      media_avatar.file.url(size)
    elsif avatar.present?
      avatar
    elsif email.present?
      hash = Digest::MD5.hexdigest(email)
      "https://api.adorable.io/avatars/64/#{hash}"
    else
      nil
    end
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

  def pushover_values(type = :create)
    translation_values = {
      name: name.blank? ? email : name,
      email: email,
    }
    if type == :create
      super.merge({
        title: I18n.t(:'common.notification.user.created.title', translation_values),
        message: I18n.t(:'common.notification.user.created.message', translation_values),
        sound: 'bugle',
        url: Rails.application.routes.url_helpers.user_url(self)
      })
    else
      super.merge({
        title: I18n.t(:'common.notification.user.destroyed.title', translation_values),
        message: I18n.t(:'common.notification.user.destroyed.message', translation_values),
        sound: 'siren',
      })
    end
  end

  def self.from_omniauth(auth_hash, honeypot)
    data = auth_hash.info

    user = User.find_or_create_by(email: data[:email]) do |u|
      u.name = data[:name]
      u.password = Devise.friendly_token[0,20]
      u.avatar = data[:image]
      u.registration_data = self.registration_data_hash(auth_hash.provider, data[:email], honeypot)
    end
    if data[:image].present? && user.avatar.blank?
      user.avatar = data[:image]
      user.save
    end
    user
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
