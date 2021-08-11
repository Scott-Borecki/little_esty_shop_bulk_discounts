class Invoice < ApplicationRecord
  enum status: [:cancelled, :'in progress', :completed]

  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :status, presence: true

  def self.incomplete_invoices
    joins(:invoice_items)
      .where.not(invoice_items: { status: :shipped })
      .order(created_at: :asc)
      .distinct
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def discounted_invoice_items
    invoice_items
      .joins(item: { merchant: :bulk_discounts })
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group(:id)
  end

  def revenue_discount
    discounted_invoice_items.sum do |invoice_item|
      invoice_item.revenue * invoice_item.max_discount_percentage / 100
    end
  end

  def total_discounted_revenue
    total_revenue - revenue_discount
  end

  def customer_full_name
    customer.full_name
  end

  def customer_address
    customer.address
  end

  def customer_city_state_zip
    customer.city_state_zip
  end
end
