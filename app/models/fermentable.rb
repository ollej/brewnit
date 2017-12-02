class Fermentable < ApplicationRecord
  enum grain_type: {
    grain: 'Grain',
    sugar: 'Sugar',
    extract: 'Extract',
    dry_extract: 'Dry Extract',
    adjunct: 'Adjunct'
  }

  validates :name, presence: true
  validates :amount, presence: true, numericality: true
  validates :ebc, presence: true, numericality: true
  validates :grain_type, presence: true, inclusion: { in: Fermentable.grain_types.keys }

  default_scope { order(amount: :desc) }
end
