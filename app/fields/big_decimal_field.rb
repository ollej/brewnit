require "administrate/field/base"

class BigDecimalField < Administrate::Field::Base
  def to_s
    data.round(options.fetch(:decimals, 2))
  end
end
