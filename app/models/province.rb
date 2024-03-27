class Province < ApplicationRecord
  has_many :addresses

  def calculate_taxes(amount)
    (gst_rate.to_f * amount) + (pst_rate.to_f * amount) + (hst_rate.to_f * amount)
  end
end