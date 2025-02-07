class Yeast < ApplicationRecord
  enum :form, {
    liquid: 'Liquid',
    dry: 'Dry',
    slant: 'Slant',
    culture: 'Culture'
  }
  enum :yeast_type, {
    ale: 'Ale',
    lager: 'Lager',
    wheat: 'Wheat',
    wine: 'Wine',
    champagne: 'Champagne'
  }

  validates :name, presence: true
  validates :amount, presence: true, numericality: true
  validates :weight, inclusion: { in: [true, false] }
  validates :form, presence: true, inclusion: { in: Yeast.forms.keys }
  validates :yeast_type, presence: true, inclusion: { in: Yeast.yeast_types.keys }

  default_scope { order(created_at: :asc) }
end
