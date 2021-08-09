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
      .order('revenue desc')
      .limit(number)
  end

  def favorite_customers
    transactions.joins(invoice: :customer)
                .where('result = ?', 1)
                .select("customers.*,
                         count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .limit(5)
  end

  def ordered_items_to_ship
    item_ids = InvoiceItem.where.not(status: :shipped)
                          .order(:created_at)
                          .pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end.uniq
  end

  def top_5_items
     items.joins(invoices: :transactions)
          .where('transactions.result = 1')
          .select(
            "items.*,
            sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue"
          )
          .group(:id)
          .order('total_revenue desc')
          .limit(5)
  end

  def best_day
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
