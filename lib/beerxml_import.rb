class BeerxmlImport
  def initialize(recipe, beerxml)
    @recipe = recipe
    @beerxml = beerxml
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

  def parse
    parser = NRB::BeerXML::Parser.new(perform_validations: false)
    xml = StringIO.new(@beerxml)
    recipe = parser.parse(xml)
    BeerRecipe::RecipeWrapper.new(recipe.records.first)
  end

  def extract_recipe
    @recipe.name = beerxml_data.name unless @recipe.name.present?
    @recipe.abv = beerxml_data.abv
    @recipe.ibu = beerxml_data.ibu
    @recipe.og = beerxml_data.og
    @recipe.fg = beerxml_data.fg
    @recipe.style_code = beerxml_data.style_code
    @recipe.style_guide = beerxml_data.style&.style_guide || ''
    @recipe.style_name = beerxml_data.style&.name || ''
    @recipe.batch_size = beerxml_data.batch_size
    @recipe.color = beerxml_data.color_ebc
    @recipe.brewer = beerxml_data.brewer || ''
    if beerxml_data.equipment.present?
      @recipe.equipment = beerxml_data.equipment&.name || ''
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
    beerxml_data.fermentables&.each do |fermentable|
      @details.fermentables.build(
        name: fermentable.name,
        amount: fermentable.amount,
        ebc: fermentable.color_ebc,
        grain_type: find_grain_type(fermentable.type),
        yield: fermentable.yield,
        potential: fermentable.potential.to_f,
        after_boil: fermentable.add_after_boil || true
      )
    end
  end

  def extract_hops
    beerxml_data.hops&.each do |hop|
      @details.hops.build(
        name: hop.name,
        amount: hop.amount.to_f,
        use_time: normalize_time(hop),
        alpha_acid: hop.alpha,
        use: find_hop_use(hop.use),
        form: find_hop_form(hop.form)
      )
    end
  end

  def extract_miscs
    beerxml_data.miscs&.each do |misc|
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
    beerxml_data.yeasts&.each do |yeast|
      @details.yeasts.build(
        name: yeast.name,
        amount: normalize_amount(yeast.amount || 1, yeast.amount_is_weight),
        weight: yeast.amount_is_weight || true,
        yeast_type: find_yeast_type(yeast.type),
        form: find_yeast_form(yeast.form)
      )
    end
  end

  def extract_mash_steps
    beerxml_data.mash&.steps&.each do |step|
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
    @details.brewed_at = Date.parse(beerxml_data.date) if beerxml_data.date
    @details.batch_size = beerxml_data.batch_size
    @details.boil_time = beerxml_data.boil_time
    @details.efficiency = beerxml_data.efficiency
    @details.boil_size = beerxml_data.boil_size
    @details.og = beerxml_data.og
    @details.fg = beerxml_data.fg
    unless beerxml_data.mash.nil?
      @details.sparge_temp = beerxml_data.mash.sparge_temp
      @details.grain_temp = beerxml_data.mash.grain_temp
    end
    @details.carbonation = beerxml_data.carbonation || 0
    @details.style = find_style(beerxml_data.style)
  end

  def beerxml_data
    @beerxml_data ||= parse
  end

  def find_style(style)
    if style.style_guide == 'SHBF 2017'
      Style.by_code(style.category_number, style.style_letter).first
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
