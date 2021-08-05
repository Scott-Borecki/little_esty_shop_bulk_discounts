class Invoice < ApplicationRecord
  enum status: [:cancelled, :"in progress", :completed]

  belongs_to :customer

  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :status, presence: true
  validates :customer_id, presence: true

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end
end
