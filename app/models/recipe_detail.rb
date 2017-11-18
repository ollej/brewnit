class RecipeDetail < ApplicationRecord
  belongs_to :recipe
  has_many :fermentables, dependent: :destroy
  has_many :hops, dependent: :destroy
  has_many :miscs, dependent: :destroy
  has_many :yeasts, dependent: :destroy

  def find_ingredient(type, id)
  end

  def add_ingredient(type, data)
  end
end
