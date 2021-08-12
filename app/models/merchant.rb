class Merchant < ApplicationRecord
  enum status: [:enabled, :disabled]

  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :status, presence: true

  def self.top_merchants_by_revenue(number = 5)
    joins(:transactions)
      .merge(Transaction.successful)
      .select(
        'merchants.*,
        SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue'
      )
      .group(:id)
      .order(revenue: :desc)
      .limit(number)
  end

  def top_customers_by_transactions(number = 5)
    items.joins(invoices: [:transactions, :customer])
         .merge(Transaction.successful)
         .select('customers.*,
                 COUNT(distinct transactions.id) as number_transactions')
         .group('customers.id')
         .order('number_transactions desc')
         .limit(number)
  end

  def items_ready_to_ship
    invoice_items.joins(:invoice)
                 .select('invoice_items.*,
                          items.name AS item_name,
                          invoices.created_at AS invoice_created_at')
                 .where.not(status: :shipped)
                 .order('invoices.created_at asc')
  end

  def top_items_by_revenue(number = 5)
     items.joins(invoices: :transactions)
          .merge(Transaction.successful)
          .select(
            "items.*,
            SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue"
          )
          .group(:id)
          .order(total_revenue: :desc)
          .limit(number)
  end

  def top_revenue_day
    invoices
      .joins(:transactions)
      .merge(Transaction.successful)
      .select(
        'invoices.created_at',
        'SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue'
      )
      .group(:id)
      .order('revenue desc', 'created_at desc')
      .first
      .formatted_date
  end
end
