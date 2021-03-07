class IngredientList
  include ActionView::Helpers::NumberHelper

  def initialize(recipe)
    @recipe = recipe
    @items = {}
  end

  def build
    @items = {}
    build_fermentables
    build_hops
    build_yeasts
    build_miscs
    self
  end

  def items
    @items.values
  end

  def fermentables
    items_by_type(:fermentable)
  end

  def hops
    items_by_type(:hop)
  end

  def yeasts
    items_by_type(:yeast)
  end

  def miscs
    items_by_type(:misc)
  end

  private
  def items_by_type(type)
    @items.values.select { |item| item.type == type }
  end

  def build_fermentables
    @recipe.detail.fermentables.each do |fermentable|
      add_item(
        name: fermentable.name,
        amount: fermentable.amount.round(2),
        unit: I18n.t(:'recipe_shopping_list.units.kg'),
        type: :fermentable
      )
    end
  end

  def build_hops
    @recipe.detail.hops.each do |hops|
      add_item(
        name: hops.name,
        amount: hops.amount.to_i,
        unit: I18n.t(:'recipe_shopping_list.units.gr'),
        type: :hop
      )
    end
  end

  def build_yeasts
    @recipe.detail.yeasts.each do |yeast|
      name = "#{yeast.name} #{yeast.product_id}"
      add_item(
        name: name,
        amount: 1,
        unit: I18n.t(:'recipe_shopping_list.units.packet'),
        type: :yeast
      )
    end
  end

  def build_miscs
    @recipe.detail.miscs.each do |misc|
      add_item(
        name: misc.name,
        amount: misc.amount.round(2),
        unit: I18n.t(:'recipe_shopping_list.units.gr'),
        type: :misc
      )
    end
  end

  def add_item(**data)
    name = data[:name]
    if @items[name].present?
      @items[name].add_amount(data[:amount])
    else
      @items[name] = IngredientItem.new(**data)
    end
  end
end
