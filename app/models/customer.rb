class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true, numericality: true, length: { is: 5 }

  def self.top_customers
    joins(:transactions)
      .where('result = ?', 1)
      .group(:id)
      .select('customers.*, count(transactions.result) as top_result')
      .order(top_result: :desc)
      .limit(5)
  end

  def number_of_transactions
    transactions.where('result = ?', 1)
                .count
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
