class Item < ApplicationRecord
  enum status: { disabled: 0, enabled: 1 }

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  delegate :top_revenue_day, to: :invoices
  delegate :top_customers, to: :customers

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def self.top_items(args = {})
    args[:limit] ||= 5
    args[:order_by] ||= 'total_revenue desc'

    joins(invoices: :transactions)
      .merge(Transaction.successful)
      .select('items.*,
               COUNT(DISTINCT transactions.id) AS transaction_count,
               SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue,
               SUM(invoice_items.quantity) AS total_items')
      .group(:id)
      .order(args[:order_by])
      .limit(args[:limit])
  end

  def self.total_items_sold
    joins(invoice_items: :invoice)
      .merge(Invoice.paid)
      .sum('invoice_items.quantity')
  end
end
