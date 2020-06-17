class BeerxmlParser
  attr_reader :beerxml

  def initialize(beerxml)
    @beerxml = beerxml
  end

  def parse_recipes
    parser = NRB::BeerXML::Parser.new(perform_validations: false)
    xmldoc = StringIO.new(@beerxml)
    recipe = parser.parse(xmldoc)
    recipe.records.map { |record| BeerRecipe::RecipeWrapper.new(record) }
  end

  def many?
    recipes.size > 1
  end

  def recipe
    recipes.first
  end

  def recipes
    @recipes ||= parse_recipes
  end
end
