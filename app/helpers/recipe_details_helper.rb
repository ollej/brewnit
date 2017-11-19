module RecipeDetailsHelper

  def ebc_hex(ebc)
    return "#ffffff" if ebc.nil? || ebc == 0
    f = BeerRecipe::Formula.new
    "#%02x%02x%02x" % f.srm_to_rgb(f.ebc_to_srm(ebc))
  end
end
