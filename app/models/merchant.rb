class Merchant < ApplicationRecord
  enum status: [:enabled, :disabled]

  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.top_merchants_by_revenue(number = 5)
    joins(:transactions)
      .select(
        'merchants.*,
        sum(invoice_items.quantity * invoice_items.unit_price) AS revenue'
      )
      .where(transactions: { result: :success })
      .group(:id)
      .order(revenue: :desc)
      .limit(number)
  end

  def top_customers_by_transactions(number = 5)
    items.joins(invoices: [:transactions, :customer])
         .select('customers.*,
                 count(distinct transactions.id) as number_transactions')
         .group('customers.id')
         .where(transactions: { result: 1 })
         .order('number_transactions desc')
         .limit(number)
  end

  def ordered_items_to_ship
    item_ids = InvoiceItem.where.not(status: :shipped)
                          .order(:created_at)
                          .pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end.uniq
  end

  def top_items_by_revenue(number = 5)
     items.joins(invoices: :transactions)
          .where(transactions: { result: 1 })
          .select(
            "items.*,
            sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue"
          )
          .group(:id)
          .order(total_revenue: :desc)
          .limit(number)
  end

  def top_revenue_day
    invoices
      .select(
        'invoices.created_at',
        'SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue'
      )
      .joins(:transactions)
      .where(transactions: { result: :success })
      .group(:id)
      .order('revenue desc', 'created_at desc')
      .first
      .formatted_time
  end
end
