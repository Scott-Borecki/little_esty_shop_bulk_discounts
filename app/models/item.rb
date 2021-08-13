class Item < ApplicationRecord
  enum status: [:disabled, :enabled]

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  delegate :best_day, to: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def self.top_customers_by_transactions(number = 5)
    joins(invoices: [:transactions, :customer])
      .merge(Transaction.successful)
      .select('customers.*,
              COUNT(distinct transactions.id) as number_transactions')
      .group('customers.id')
      .order('number_transactions desc')
      .limit(number)
  end

  def self.top_items_by_revenue(number = 5)
    joins(invoices: :transactions)
      .merge(Transaction.successful)
      .select(
        "items.*,
        SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue"
      )
      .group(:id)
      .order(total_revenue: :desc)
      .limit(number)
  end
end
