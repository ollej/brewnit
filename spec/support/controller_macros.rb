module ControllerMacros
  def login_admin
    let(:admin) {
      user = User.new(
        name: 'devise admin',
        email: 'bar@foo.com',
        password: 'password',
        admin: true
      )
      user.skip_confirmation!
      user.save!
      user
    }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in admin
    end
  end

  def login_user
    let(:user) {
      user = User.new(name: 'devise user', email: 'foo@bar.com', password: 'password')
      user.skip_confirmation!
      user.save!
      user
    }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end
end
