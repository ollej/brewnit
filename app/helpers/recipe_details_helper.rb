module RecipeDetailsHelper
  def ebc_hex(ebc)
    return "#ffffff" if ebc.nil? || ebc == 0
    f = BeerRecipe::Formula.new
    "#%02x%02x%02x" % f.srm_to_rgb(f.ebc_to_srm(ebc))
  end

  def weight_options
    {
      I18n.t(:'recipe_detail.weight_option.weight') => '1',
      I18n.t(:'recipe_detail.weight_option.volume') => '0'
    }
  end

  def weight_selection(ingredient)
    if ingredient.weight?
      I18n.t(:'recipe_detail.weight_option.weight')
    else
      I18n.t(:'recipe_detail.weight_option.volume')
    end
  end
end
