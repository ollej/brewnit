class User < ActiveRecord::Base
  has_many :recipes, dependent: :destroy

  acts_as_commontator
  acts_as_voter

  # Unused: :recoverable, :confirmable, :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :registerable, :timeoutable, :omniauthable, omniauth_providers: [:google]

  scope :by_query, lambda { |query, col = :name|
    where arel_table[col].matches("%#{query}%")
  }

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
    return true if self == resource.user
    return true if admin?
    return false
  end

  def can_show?(resource)
    resource.public? || can_modify?(resource)
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
end
