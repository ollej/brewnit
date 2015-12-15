class User < ActiveRecord::Base
  has_many :recipes

  # Unused: :recoverable, :confirmable, :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :registerable, :timeoutable, :omniauthable, omniauth_providers: [:google]

  def admin?
    admin
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

    User.find_or_create_by(email: data[:email]) do |u|
      u.name = data[:name]
      u.password = Devise.friendly_token[0,20]
      u.avatar = data[:image]
    end
  end
end
