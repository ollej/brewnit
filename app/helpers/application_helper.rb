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

  def medal_tag(placement, size=:small)
    return unless placement.present?
    %Q{<div class="badge #{size}">
      <div class="lanyard">
        <div class="ribbon left sweden"></div>
        <div class="ribbon right sweden"></div>
      </div>
      <div class="circle #{placement.medal} border">
        #{placement.medal_position}
      </div>
    </div>}.html_safe
  end

  def medal_options
    [
      [t(:'recipe_events.medals.none'), ''],
      [t(:'recipe_events.medals.gold'), 'gold'],
      [t(:'recipe_events.medals.silver'), 'silver'],
      [t(:'recipe_events.medals.bronze'), 'bronze'],
    ]
  end

  def icon(type=nil)
    content_tag(:i, '', class: "fa fa-#{type}") if type.present?
  end

  def badge(content, opts={})
    opts[:class] = Array(opts[:class])
    opts[:class] << 'pure-badge'
    opts[:class] << "pure-badge-#{opts[:type]}" if opts[:type].present?
    data = {}
    if opts[:tooltip].present?
      data[:balloon] = opts[:tooltip]
      data[:'balloon-pos'] = 'down'
    end
    content_tag(:span, class: opts[:class], data: data) do
      concat icon(opts[:icon])
      concat content
    end
  end

end
