module UsersHelper
  def twitter_url(handle)
    "https://twitter.com/#{handle.gsub(/^@/, '')}"
  end

  def instagram_url(handle)
    "https://instagram.com/#{handle}"
  end
end
