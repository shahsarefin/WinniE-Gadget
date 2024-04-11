class Province < ApplicationRecord
  has_many :addresses

  def calculate_taxes(amount)
    (gst_rate.to_f + pst_rate.to_f + hst_rate.to_f) / 100 * amount
  end
end