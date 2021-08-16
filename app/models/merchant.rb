class Merchant < ApplicationRecord
  enum status: { enabled: 0, disabled: 1 }

  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  delegate :top_customers, to: :customers
  delegate :ready_to_ship, to: :invoice_items, prefix: true
  delegate :top_revenue_day, to: :invoices
  delegate :top_items, :total_items_sold, to: :items

  validates :name, presence: true
  validates :status, presence: true

  def self.top_merchants_by_revenue(number = 5)
    joins(invoice_items: :invoice)
      .merge(Invoice.paid)
      .select('merchants.*,
               SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .group(:id)
      .order(total_revenue: :desc)
      .limit(number)
  end
end
