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

  def render_item(item)
    Rails.logger.debug { "rendering item: #{item.inspect}" }
    render partial: "shared/#{item.class.name.demodulize.underscore}_item", locals: { item: item }
  end

  def full_url?(url)
    uri = URI.parse(url)
    uri.hostname.present? && uri.scheme.present?
  rescue URI::Error
    false
  end

  def full_url_for(url)
    unless full_url?(url)
      asset_url(url)
    else
      url
    end
  end

  def shorten(text, len = 45)
    truncate(text, length: len, omission: '…')
  end

  def shorten_strip(text, len = 50)
    truncate(strip_tags(text), length: len, omission: '…')
  end
end
