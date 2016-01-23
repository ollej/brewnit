class User < ActiveRecord::Base
  ALLOWED_TAGS = %w(b i strong em br p small del strike s ins u sub sup mark hr q)
  before_validation :cleanup_fields
  has_many :recipes, dependent: :destroy

  after_create :notify_pushover

  validates :name, presence: true
  validates_format_of :avatar,
    with: %r{\Ahttps?://.+/.+\.(gif|jpe?g|png)\z}i,
    message: I18n.t(:'activerecord.errors.models.user.attributes.avatar.format'),
    allow_blank: true

  acts_as_commontator
  acts_as_voter

  # Unused: :recoverable, :confirmable, :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :registerable, :timeoutable, :omniauthable, omniauth_providers: [:google]

  scope :by_query, lambda { |query, col = :name|
    where arel_table[col].matches("%#{query}%")
  }
  scope :ordered, -> { order("name = '', name ASC, brewery ASC") }

  def admin?
    admin
  end

  def avatar_image
    if avatar.present?
      avatar
    elsif email.present?
      hash = Digest::MD5.hexdigest(email)
      "https://secure.gravatar.com/avatar/#{hash}?s=100&d=retro"
    else
      nil
    end
  end

  def can_modify?(resource)
    return true if self == resource
    return true if self == resource.user
    return true if admin?
    return false
  end

  def can_show?(resource)
    resource.public? || can_modify?(resource)
  end

  def cleanup_fields
    if !url.blank? && !url.start_with?('http')
      self.url = "http://#{url.strip}"
    end
    if !twitter.blank? && !twitter.start_with?('@')
      self.twitter = "@#{twitter.strip}"
    end
    if !presentation.blank? && presentation_changed?
      self.presentation = Rails::Html::WhiteListSanitizer.new.sanitize(presentation, tags: ALLOWED_TAGS)
    end
  end

  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.find_or_create_by(email: data[:email]) do |u|
      u.name = data[:name]
      u.password = Devise.friendly_token[0,20]
      u.avatar = data[:image]
    end
    if data[:image].present? && user.avatar.blank?
      user.avatar = data[:image]
      user.save
    end
    user
  end

  def notify_pushover
    return if Rails.env.development?
    values = {
      name: name.blank? ? email : name,
      email: email,
      sound: 'bugle',
    }
    Pushover.notification(
      title: I18n.t(:'common.notification.user.created.title', values),
      message: I18n.t(:'common.notification.user.created.message', values),
      url: Rails.application.routes.url_helpers.user_url(self)
    )
  end

end
