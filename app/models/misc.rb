class Misc < ApplicationRecord
  enum :use, {
    mash: 'Mash',
    boil: 'Boil',
    primary: 'Primary',
    secondary: 'Secondary',
    bottling: 'Bottling'
  }
  enum :misc_type, {
    spice: 'Spice',
    fining: 'Fining',
    water_agent: 'Water Agent',
    herb: 'Herb',
    flavor: 'Flavor',
    other: 'Other'
  }

  validates :name, presence: true
  validates :amount, presence: true, numericality: true
  validates :weight, inclusion: { in: [true, false] }
  validates :use_time, presence: true, numericality: true
  validates :use, presence: true, inclusion: { in: Misc.uses.keys }
  validates :misc_type, presence: true, inclusion: { in: Misc.misc_types.keys }

  default_scope { order(created_at: :asc) }
end
