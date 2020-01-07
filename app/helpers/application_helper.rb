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
    return url if full_url?(url)
    asset_url(url)
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
      [I18n.t(:'recipe_events.medals.none'), ''],
      [I18n.t(:'recipe_events.medals.gold'), 'gold'],
      [I18n.t(:'recipe_events.medals.silver'), 'silver'],
      [I18n.t(:'recipe_events.medals.bronze'), 'bronze'],
    ]
  end

  def fermentable_type_options
    Fermentable.grain_types.map { |k, v|
      [I18n.t("recipe_detail.fermentable_type.#{k}"), v]
    }
  end

  def hop_use_options
    Hop.uses.map { |k, v|
      [I18n.t("recipe_detail.hop_use.#{k}"), v]
    }
  end

  def hop_form_options
    Hop.forms.map { |k, v|
      [I18n.t("recipe_detail.hop_form.#{k}"), v]
    }
  end

  def misc_use_options
    Misc.uses.map { |k, v|
      [I18n.t("recipe_detail.misc_use.#{k}"), v]
    }
  end

  def misc_type_options
    Misc.misc_types.map { |k, v|
      [I18n.t("recipe_detail.misc_type.#{k}"), v]
    }
  end

  def yeast_form_options
    Yeast.forms.map { |k, v|
      [I18n.t("recipe_detail.yeast_form.#{k}"), v]
    }
  end

  def yeast_type_options
    Yeast.yeast_types.map { |k, v|
      [I18n.t("recipe_detail.yeast_type.#{k}"), v]
    }
  end

  def mash_type_options
    MashStep.mash_types.map { |k, v|
      [I18n.t("recipe_detail.mash_type.#{k}"), v]
    }
  end

  def icon(type=nil)
    content_tag(:i, '', class: "fas fa-#{type}") if type.present?
  end

  def badge(content, opts={})
    opts[:class] = Array(opts[:class])
    opts[:class] << 'pure-badge'
    opts[:class] << "pure-badge-#{opts[:type]}" if opts[:type].present?
    data = tooltip_data(opts[:tooltip])
    content_tag(:span, class: opts[:class], data: data) do
      concat icon(opts[:icon])
      concat content
    end
  end

  def form_info_icon(text, position: 'down', length: 'medium')
    content_tag(:span, class: 'form-info-icon',
                data: tooltip_data(text, position: position, length: length)) do
      concat icon('info-circle')
    end
  end

  def trash_icon(url, cls: nil, remote: true)
    cls ||= 'inline-button destroy-button'
    link_to url, method: :delete, remote: remote, class: cls,
      data: { confirm: t(:'common.are_you_sure') } do
        concat icon('trash')
    end
  end

  def trash_button(url, text, tooltip: nil, classes: 'pure-button secondary-button')
    data = tooltip_data(tooltip, length: 'small')
    data[:confirm] = I18n.t(:'common.are_you_sure')
    link_to url, method: :delete, data: data, class: classes do
      concat icon('trash')
      concat ' ' + text
    end
  end

  def tooltip_data(tooltip, position: 'down', length: 'medium')
    return {} unless tooltip.present?
    return tooltip if tooltip.kind_of? Hash
    {
      :'balloon' => tooltip,
      :'balloon-pos' => position,
      :'balloon-length' => length
    }
  end

  def can_show?(model)
    user_signed_in? && current_user.can_show?(model)
  end

  def can_modify?(model)
    user_signed_in? && current_user.can_modify?(model)
  end

  def disallow_tracking?
    Rails.env.development? ||
      (request.headers['HTTP_DNT'].present? && request.headers['HTTP_DNT'] == "1") ||
      (request.headers['HTTP_X_DO_NOT_TRACK'].present? && request.headers['HTTP_X_DO_NOT_TRACK'] == "1")
  end
end
