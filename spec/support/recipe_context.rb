module RecipeContext
  extend RSpec::SharedContext

  let(:recipe) { Recipe.create!(recipe_attributes) }
  let(:recipe_attributes) do
    {
      user: user,
      name: 'recipe test'
    }
  end

  let(:recipe_with_beerxml) { Recipe.create!(recipe_with_beerxml_attributes) }
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:recipe_with_beerxml_attributes) do
    {
      user: user,
      name: 'recipe test',
      beerxml: beerxml,
      complete: true
    }
  end
end
