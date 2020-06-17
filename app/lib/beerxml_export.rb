class BeerxmlExport
  def initialize(recipe)
    @recipe = recipe
  end

  def assigns
    {
      recipe: @recipe,
      details: @recipe.detail,
      hops: @recipe.detail.hops,
      fermentables: @recipe.detail.fermentables,
      miscs: @recipe.detail.miscs,
      yeasts: @recipe.detail.yeasts,
      mash_steps: @recipe.detail.mash_steps,
      style: @recipe.detail.style
    }
  end

  def render
    # TODO: Validate xml with BeerRecipe
    ApplicationController.render(
      template: 'recipe_details/show.xml.builder',
      assigns: assigns
    )
  end
end
