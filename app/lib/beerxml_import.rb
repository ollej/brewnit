class BeerxmlImport
  attr_reader :beer_recipe

  def initialize(recipe, beer_recipe)
    @recipe = recipe
    @beer_recipe = beer_recipe
  end

  def run
    @details = @recipe.build_detail
    clear_data
    extract_fermentables
    extract_hops
    extract_miscs
    extract_yeasts
    extract_mash_steps
    extract_details
    extract_recipe
  end

  def extract_recipe
    @recipe.name = beer_recipe.name unless @recipe.name.present?
    @recipe.abv = beer_recipe.abv
    @recipe.ibu = beer_recipe.ibu
    @recipe.og = beer_recipe.og
    @recipe.fg = beer_recipe.fg
    @recipe.style_code = beer_recipe.style_code
    @recipe.style_guide = beer_recipe.style&.style_guide || ''
    @recipe.style_name = beer_recipe.style&.name || ''
    @recipe.batch_size = beer_recipe.batch_size
    @recipe.color = beer_recipe.color_ebc
    @recipe.brewer = beer_recipe.brewer || ''
    if beer_recipe.equipment.present?
      @recipe.equipment = beer_recipe.equipment&.name || ''
    else
      @recipe.equipment = @recipe.user.equipment || ''
    end
    @recipe.complete = true
  end

  private

  def clear_data
    @details.style = nil
    @details.fermentables.destroy_all
    @details.hops.destroy_all
    @details.miscs.destroy_all
    @details.yeasts.destroy_all
    @details.mash_steps.destroy_all
  end

  def extract_fermentables
    beer_recipe.fermentables&.each do |fermentable|
      @details.fermentables.build(
        name: fermentable.name,
        amount: fermentable.amount.round(2),
        ebc: fermentable.color_ebc,
        grain_type: find_grain_type(fermentable.type),
        yield: fermentable.yield || 0,
        potential: fermentable.potential.to_f,
        after_boil: fermentable.add_after_boil || true
      )
    end
  end

  def extract_hops
    beer_recipe.hops&.each do |hop|
      @details.hops.build(
        name: hop.name,
        amount: hop.amount.to_f.round(2),
        use_time: normalize_time(hop),
        alpha_acid: hop.alpha,
        use: find_hop_use(hop.use),
        form: find_hop_form(hop.form)
      )
    end
  end

  def extract_miscs
    beer_recipe.miscs&.each do |misc|
      @details.miscs.build(
        name: misc.name,
        amount: normalize_amount(misc.amount, misc.amount_is_weight),
        weight: misc.amount_is_weight || true,
        use_time: misc.time,
        use: find_misc_use(misc.use),
        misc_type: find_misc_type(misc.type),
      )
    end
  end

  def extract_yeasts
    beer_recipe.yeasts&.each do |yeast|
      @details.yeasts.build(
        name: yeast.name,
        product_id: yeast.product_id,
        amount: normalize_amount(yeast.amount || 1, yeast.amount_is_weight),
        weight: yeast.amount_is_weight || true,
        yeast_type: find_yeast_type(yeast.type),
        form: find_yeast_form(yeast.form)
      )
    end
  end

  def extract_mash_steps
    beer_recipe.mash&.steps&.each do |step|
      @details.mash_steps.build(
        name: step.name,
        step_temperature: step.step_temp,
        step_time: step.step_time,
        infuse_amount: step.infuse_amount,
        ramp_time: step.ramp_time,
        end_temperature: step.end_temp,
        mash_type: find_mash_type(step.type),
      )
    end
  end

  def extract_details
    begin
      @details.brewed_at = Date.parse(beer_recipe.date) if beer_recipe.date
    rescue ArgumentError
    end
    @details.batch_size = beer_recipe.batch_size
    @details.boil_time = beer_recipe.boil_time
    @details.efficiency = beer_recipe.efficiency
    @details.boil_size = beer_recipe.boil_size
    @details.og = beer_recipe.og
    @details.fg = beer_recipe.fg
    unless beer_recipe.mash.nil?
      @details.sparge_temp = beer_recipe.mash.sparge_temp
      @details.grain_temp = beer_recipe.mash.grain_temp
    end
    @details.carbonation = beer_recipe.carbonation || 0
    @details.style = find_style(beer_recipe.style)
  end

  def find_style(style)
    if style&.style_guide && style&.style_guide.start_with?('SHBF')
      Style.by_code(style.style_guide, style.category_number, style.style_letter).first
    end
  end

  def find_grain_type(type)
    Fermentable.grain_types.key(type) || 'Grain'
  end

  def find_hop_use(use)
    Hop.uses.key(use) || 'Boil'
  end

  def find_hop_form(form)
    Hop.forms.key(form) || 'Leaf'
  end

  def find_misc_use(use)
    Misc.uses.key(use) || 'Mash'
  end

  def find_misc_type(type)
    Misc.misc_types.key(type) || 'Other'
  end

  def find_yeast_type(type)
    Yeast.yeast_types.key(type) || 'Ale'
  end

  def find_yeast_form(form)
    Yeast.forms.key(form) || 'Dry'
  end

  def find_mash_type(type)
    MashStep.mash_types.key(type) || 'Temperature'
  end

  def normalize_amount(amount, is_weight)
    if is_weight
      amount * 1000
    else
      amount
    end
  end

  def normalize_time(hop)
    if hop.use == 'Dry Hop'
      hop.time.to_f / 24 / 60
    else
      hop.time.to_f
    end
  end
end
