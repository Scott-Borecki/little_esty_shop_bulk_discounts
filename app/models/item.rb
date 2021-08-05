class Item < ApplicationRecord
  enum status: [:disabled, :enabled]

  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def best_day
    invoices
      .joins(:invoice_items)
      .where('invoices.status = 2')
      .select('invoices.*,
               sum(invoice_items.unit_price * invoice_items.quantity) as money')
      .group(:id)
      .order("money desc", "created_at desc")
      .first
      .created_at
      .to_date
  end
end
