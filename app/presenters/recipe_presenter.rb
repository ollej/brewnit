class RecipePresenter
  def initialize(recipe)
    @recipe = recipe
    @beerxml = recipe.beerxml_details
    @style = @beerxml.style
  end

  def date
    date = if @beerxml.date.blank?
      @recipe.created_at
    else
      if @beerxml.date.kind_of? Date
        @beerxml.date
      else
        Date.parse(@beerxml.date)
      end
    end
    I18n.l(date, format: :long)
  end

  def color_of(item)
    '%.0f' % item.color_ebc
  end

  def amount_percent(f)
    "#{'%.1f' % f.amount_percent} #{I18n.t(:'beerxml.percent_sign')}"
  end

  def equipment_name
    if @beerxml.equipment.present?
      name = @beerxml.equipment.name
      if @beerxml.equipment.tun_volume.present?
        name += " (#{@beerxml.equipment.tun_volume} #{I18n.t(:'beerxml.liter_abbr')})"
      end
    else
      ""
    end
  end

  def og_min
    '%.3f' % (@beerxml.style.og_min || 0)
  end

  def og_max
    '%.3f' % (@beerxml.style.og_max || 0)
  end

  def style_has_values?
    @style.category_number.present? && @style.style_letter.present? &&
      @style.category.present? &&
      @style.og_min.present? && @style.og_max.present? &&
      @style.fg_min.present? && @style.fg_max.present? &&
      @style.color_min.present? && @style.color_max.present? &&
      @style.ibu_min.present? && @style.ibu_max.present?
  end

  def style_type
    return unless @beerxml.style_code.present? && @style.style_guide.present?
    "(#{[ @beerxml.style_code, @style.style_guide ].join(' / ')})"
  end
end
