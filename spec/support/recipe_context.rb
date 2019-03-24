module RecipeContext
  extend RSpec::SharedContext

  let(:user) { User.new }

  let(:recipe) { Recipe.create!(recipe_attributes) }
  let(:recipe_attributes) do
    {
      user: user,
      name: 'recipe test'
    }
  end

  let(:recipe_with_beerxml) {
    recipe = Recipe.new(recipe_with_beerxml_attributes)
    BeerxmlImport.new(recipe, parsed_beerxml).run
    recipe.save!
    recipe
  }
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:parsed_beerxml) { BeerxmlParser.new(beerxml).recipe }
  let(:recipe_presenter) { RecipePresenter.new(recipe_with_beerxml, parsed_beerxml) }
  let(:recipe_with_beerxml_attributes) do
    {
      user: user,
      name: 'recipe test',
      beerxml: beerxml,
      complete: true
    }
  end
end
