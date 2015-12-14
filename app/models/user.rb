class User < ActiveRecord::Base
  # Unused: :recoverable, :registerable, :confirmable, :lockable
  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    unless user
      user = User.create(
        name: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    end

    user
  end
end
