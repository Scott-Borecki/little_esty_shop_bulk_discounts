class InvoiceItem < ApplicationRecord
  scope :total_revenue, -> { sum('invoice_items.quantity * invoice_items.unit_price') }
  scope :not_shipped, -> { where.not(status: :shipped) }

  enum status: { pending: 0, packaged: 1, shipped: 2 }

  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  def self.ready_to_ship
    not_shipped
      .joins(:invoice, :item)
      .select('invoice_items.*,
               items.name AS item_name,
               invoices.created_at AS invoice_created_at')
      .order('invoices.created_at asc')
  end

  def self.discounted
    joins(item: { merchant: :bulk_discounts })
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group(:id)
  end

  def self.revenue_discount
    discounted.sum do |invoice_item|
      invoice_item.revenue * invoice_item.max_discount_percentage / 100
    end
  end

  def self.total_discounted_revenue
    total_revenue - revenue_discount
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
