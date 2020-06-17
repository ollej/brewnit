class RecipeCloner
  def initialize(recipe, user, params)
    @recipe = recipe
    @user = user
    @params = params
  end

  def clone
    clone = duplicate
    BeerxmlImport.new(clone, parser.recipe).run
    clone.beerxml = @recipe.beerxml.dup
    clone
  end

  def parser
    BeerxmlParser.new(@recipe.beerxml)
  end

  def duplicate
    clone = Recipe.new(@params)
    clone.user = @user
    clone
  end
end
