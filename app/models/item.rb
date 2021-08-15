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

  def self.top_items_by_revenue(number = 5)
    joins(invoices: :transactions)
      .merge(Transaction.successful)
      .select('items.*,
               SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .order(total_revenue: :desc)
      .limit(number)
  end
end
