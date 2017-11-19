class Hop < ApplicationRecord
  enum use: {
    boil: 'Boil',
    dry_hop: 'Dry Hop',
    mash: 'Mash',
    first_wort: 'First Wort',
    aroma: 'Aroma'
  }
  enum form: {
    pellet: 'Pellet',
    plug: 'Plug',
    leaf: 'Leaf'
  }

  validates :name, presence: true
  validates :amount, presence: true, numericality: true
  validates :use_time, presence: true, numericality: true
  validates :alpha_acid, presence: true, numericality: true
  validates :use, presence: true, inclusion: { in: Hop.uses.keys }
  validates :form, presence: true, inclusion: { in: Hop.forms.keys }
end
