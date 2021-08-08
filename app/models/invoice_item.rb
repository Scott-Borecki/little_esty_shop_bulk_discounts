class InvoiceItem < ApplicationRecord
  enum status: [:pending, :packaged, :shipped]

  belongs_to :invoice
  belongs_to :item

  validates :invoice_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
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
