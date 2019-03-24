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

  scope :by_code, -> (guide, number, letter) {
    where(style_guide: guide, number: number, letter: letter)
  }
  scope :for_guide, -> (guide) {
    where(style_guide: guide).order(number: :asc, letter: :asc)
  }

  def style_code
    "#{letter} #{number}"
  end

  def self.style_options(style_guide)
    where(style_guide: style_guide).order(number: :asc, letter: :asc).map do |style|
      ["#{style.number}#{style.letter}. #{style.name}", style.id]
    end
  end

  def self.style_guides
    order(style_guide: :asc).distinct.pluck(:style_guide)
  end
end
