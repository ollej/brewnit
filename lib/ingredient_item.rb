class IngredientItem
  attr_reader :name, :amount, :unit, :type, :type_name

  TYPES = {
    fermentable: I18n.t(:'recipe_shopping_list.type.fermentable'),
    hop: I18n.t(:'recipe_shopping_list.type.hops'),
    yeast: I18n.t(:'recipe_shopping_list.type.yeast'),
    misc: I18n.t(:'recipe_shopping_list.type.miscs')
  }

  def initialize(name:, amount:, unit:, type:)
    @name = name
    @amount = amount
    @unit = unit
    @type = type
    @type_name = TYPES.fetch(type)
  end

  def add_amount(amount)
    @amount = @amount + amount
  end
end
