class InvoiceItem < ApplicationRecord
  scope :total_revenue, -> { sum('quantity * unit_price') }

  enum status: [:pending, :packaged, :shipped]

  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  def self.discounted
    joins(item: { merchant: :bulk_discounts })
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group(:id)
  end

  def revenue
    unit_price * quantity
  end

  def max_discount
    item.merchant.bulk_discounts.max_discount(quantity)
  end

  def max_discount_percentage
    max_discount.percentage_discount
  end

  def max_discount_id
    max_discount.id
  end
end
