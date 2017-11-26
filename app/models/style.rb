class Style < ApplicationRecord
  validates :style_guide, presence: true
  validates :name, presence: true
  validates :letter, presence: true
  validates :number, presence: true, numericality: true
  validates :og_min, numericality: true
  validates :og_max, numericality: true
  validates :fg_min, numericality: true
  validates :fg_max, numericality: true
  validates :ebc_min, numericality: true
  validates :ebc_max, numericality: true
  validates :ibu_min, numericality: true
  validates :ibu_max, numericality: true
  validates :abv_min, numericality: true
  validates :abv_max, numericality: true

  def self.style_options
    order(number: :asc, letter: :asc).map do |style|
      ["#{style.number}#{style.letter}. #{style.name}", style.id]
    end
  end
end
