module ApplicationHelper
  def avatar_tag(user)
    image_tag user.avatar_image
  end
end
