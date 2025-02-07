class MashStep < ApplicationRecord
  enum :mash_type, {
    infusion: 'Infusion',
    temperature: 'Temperature',
    decoction: 'Decoction'
  }

  validates :name, presence: true
  validates :step_temperature, presence: true, numericality: true
  validates :step_time, presence: true, numericality: true
  validates :water_grain_ratio, numericality: true, allow_blank: true
  validates :infuse_amount, numericality: true, allow_blank: true
  validates :infuse_temperature, numericality: true, allow_blank: true
  validates :ramp_time, numericality: true, allow_blank: true
  validates :end_temperature, numericality: true, allow_blank: true
  validates :mash_type, presence: true, inclusion: { in: MashStep.mash_types.keys }

  default_scope { order(created_at: :asc) }
end
