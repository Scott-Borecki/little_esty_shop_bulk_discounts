class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, presence: true, numericality: true
  validates :quantity_threshold, presence: true, numericality: true
  validates :merchant_id, presence: true

  def self.max_discount(quantity)
    where('quantity_threshold <= ?', quantity)
      .order(percentage_discount: :desc)
      .first
  end
end
