module UsersHelper
  def twitter_url(handle)
    "https://twitter.com/#{handle.gsub(/^@/, '')}"
  end
end
