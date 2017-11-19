class RecipeDetail < ApplicationRecord
  belongs_to :recipe
  has_many :fermentables, dependent: :destroy
  has_many :hops, dependent: :destroy
  has_many :miscs, dependent: :destroy
  has_many :yeasts, dependent: :destroy
end
