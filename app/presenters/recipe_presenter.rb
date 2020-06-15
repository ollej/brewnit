class RecipePresenter
  def initialize(recipe, beerxml = nil)
    @recipe = recipe
    @beerxml = beerxml || BeerxmlParser.new(@recipe.beerxml).recipe
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
    @style.present? &&
      @style.category_number.present? && @style.style_letter.present? &&
      @style.category.present? &&
      @style.og_min.present? && @style.og_max.present? &&
      @style.fg_min.present? && @style.fg_max.present? &&
      @style.color_min.present? && @style.color_max.present? &&
      @style.ibu_min.present? && @style.ibu_max.present?
  end

  def style_type
    return unless @recipe.style_code && @recipe.style_guide.present?
    "(#{[ @recipe.style_code, @recipe.style_guide ].join(' / ')})"
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

  def malt_data
    @beerxml.fermentables.map do |f|
      {
        label: f.name,
        value: f.formatted_amount.to_f,
        color: f.color_hex,
      }
    end
  end

  def hop_data(hop)
    {
      name: hop.name,
      size: hop.amount,
      time: hop.time,
      ibu: hop.ibu,
      aau: hop.aau,
      mgl_alpha: hop.mgl_added_alpha_acids,
      grams_per_liter: hop.amount / @recipe.batch_size,
      tooltip: self.class.hop_info(hop)
    }
  end

  def hop_additions
    hops = {}
    hops_sorted.map do |h|
      if hops[h.time]
        hops[h.time][:children] << hop_data(h)
      else
        hops[h.time] = { name: self.class.hop_addition_name(h), children: [hop_data(h)] }
      end
    end
    hops
  end

  def hops_sorted
    @beerxml.hops.sort_by { |hop| hop.time }
  end

  def hops_data
    {
      name: I18n.t(:'beerxml.hops'),
      children: hop_additions.values
    }
  end

  def self.hop_addition_name(hop)
    if hop.use == 'Boil'
      if hop.time >= 30
        I18n.t(:'beerxml.addition_bitter')
      elsif hop.time >= 10
        I18n.t(:'beerxml.addition_flavour')
      else
        I18n.t(:'beerxml.addition_aroma')
      end
    else
      I18n.t("beerxml.#{hop.use}")
    end
  end

  def self.hop_info(hop)
    "#{hop.formatted_amount} #{I18n.t(:'beerxml.grams')} #{hop.name} @ #{hop.formatted_time} #{I18n.t("beerxml.#{hop.time_unit}", default: hop.time_unit)}"
  end
end
