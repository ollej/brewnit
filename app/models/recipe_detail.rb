class RecipeDetail < ApplicationRecord
  belongs_to :recipe
  has_many :fermentables, dependent: :destroy
  has_many :hops, dependent: :destroy
  has_many :miscs, dependent: :destroy
  has_many :yeasts, dependent: :destroy
  has_many :mash_steps, dependent: :destroy
  belongs_to :style, optional: true

  validates :batch_size, numericality: true, allow_blank: true
  validates :boil_time, numericality: true, allow_blank: true
  validates :efficiency, numericality: true, allow_blank: true
  validates :boil_size, numericality: true, allow_blank: true
  validates :og, numericality: true, allow_blank: true
  validates :fg, numericality: true, allow_blank: true
  validates :sparge_temp, numericality: true, allow_blank: true
  validates :grain_temp, numericality: true, allow_blank: true
  validates :carbonation, numericality: true, allow_blank: true
end
