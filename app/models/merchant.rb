class Merchant < ApplicationRecord
  enum status: [:enabled, :disabled]

  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  delegate :items_ready_to_ship, to: :invoice_items
  delegate :top_revenue_day, to: :invoices
  delegate :top_customers_by_transactions, :top_items_by_revenue, to: :items

  validates :name, presence: true
  validates :status, presence: true

  def self.top_merchants_by_revenue(number = 5)
    joins(:transactions)
      .merge(Transaction.successful)
      .select(
        'merchants.*,
        SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue'
      )
      .group(:id)
      .order(total_revenue: :desc)
      .limit(number)
  end
end
