class ShoppingItem
  attr_reader :name, :amount, :unit, :type

  TYPES = {
    fermentable: I18n.t(:'recipe_shopping_list.type.fermentable'),
    hops: I18n.t(:'recipe_shopping_list.type.hops'),
    yeast: I18n.t(:'recipe_shopping_list.type.yeast'),
    miscs: I18n.t(:'recipe_shopping_list.type.miscs')
  }

  def initialize(name:, amount:, unit:, type:)
    @name = name
    @amount = amount
    @unit = unit
    @type = TYPES.fetch(type)
  end

  def add_amount(amount)
    @amount = @amount + amount
  end
end
