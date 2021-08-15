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

  def self.top_customers(number = 5, order_attribute = 'transaction_count', order = 'desc')
    joins(invoices: [:transactions, :invoice_items])
      .merge(Transaction.successful)
      .select('customers.*,
               COUNT(DISTINCT transactions.id) AS transaction_count,
               SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue,
               SUM(invoice_items.quantity) AS total_items')
      .group(:id)
      .order("#{order_attribute} #{order}")
      .limit(number)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def city_state_zip
    "#{city}, #{state} #{zip}"
  end
end
