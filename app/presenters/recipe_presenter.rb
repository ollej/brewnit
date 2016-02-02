class RecipePresenter
  def initialize(recipe)
    @recipe = recipe
    @beerxml = recipe.beerxml_details
    @style = @beerxml.style
  end

  def date
    date = @beerxml.date
    date = Chronic.parse(date) unless date.kind_of? Date
    date ||= @recipe.created_at
  end

  def long_date
    I18n.l(date, format: :long)
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

  def hop_grams_per_liter(hop)
    if @beerxml.batch_size > 0
      (hop.amount / @beerxml.batch_size)
    else
      0
    end
  end

  def mgl_added_alpha_acids(hop)
    if @beerxml.batch_size > 0
      '%.1f' % ((hop.alpha * hop.amount) / @beerxml.batch_size)
    else
      0
    end
  end

  def hop_aau(hop)
    '%.1f' % hop.aau
  end
end
