class Invoice < ApplicationRecord
  enum status: [:cancelled, :'in progress', :completed]

  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :status, presence: true
  validates :customer_id, presence: true

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def discounted_items
    invoice_items
      .joins(item: { merchant: :bulk_discounts })
      .select('invoice_items.*,
               MAX(percentage_discount) AS max_discount,
               invoice_items.quantity * invoice_items.unit_price AS total_revenue')
      .where('invoice_items.quantity > bulk_discounts.quantity_threshold')
      .group(:id)
  end

  def revenue_discount
    discounted_items.sum { |item| item.total_revenue * item.max_discount / 100 }
  end

  def total_discounted_revenue
    total_revenue - revenue_discount
  end
end
