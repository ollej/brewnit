module UserContext
  extend RSpec::SharedContext

  let(:user) { User.create!(user_attributes) }
  let(:user_attributes) do
    {
      name: "test user",
      email: "test@example.com",
      password: "abcd1234"
    }
  end
end
