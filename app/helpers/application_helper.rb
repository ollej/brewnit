module ApplicationHelper
  def avatar_tag(user)
    image_tag user.avatar_image
  end

  def destroy_medium_path(medium)
    meth = "#{medium.parent.class.name.underscore}_medium_path"
    send(meth, medium.parent, medium, format: :json)
  end

  def add_medium_path(medium, type)
    meth = "#{medium.parent.class.name.underscore}_add_medium_path"
    send(meth, medium.parent, medium, format: :json, medium_id: medium.id, media_type: type)
  end
end
