class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true, numericality: true, length: { is: 5 }

  def self.top_customers(args = {})
    args[:limit] ||= 5
    args[:order_by] ||= 'transaction_count desc, total_revenue desc, total_items desc'

    joins(invoices: [:transactions, :invoice_items])
      .merge(Transaction.successful)
      .select('customers.*,
               COUNT(DISTINCT invoices.id) AS transaction_count,
               SUM(DISTINCT invoice_items.quantity * invoice_items.unit_price) AS total_revenue,
               SUM(DISTINCT invoice_items.quantity) AS total_items')
      .group(:id)
      .order(args[:order_by])
      .limit(args[:limit])
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def city_state_zip
    "#{city}, #{state} #{zip}"
  end
end
