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

  def self.top_customers_by_transactions(number = 5)
    joins(:transactions)
      .merge(Transaction.successful)
      .select('customers.*, COUNT(transactions.result) as transaction_count')
      .group(:id)
      .order(transaction_count: :desc)
      .limit(number)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def city_state_zip
    "#{city}, #{state} #{zip}"
  end
end
