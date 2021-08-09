class Item < ApplicationRecord
  enum status: [:disabled, :enabled]

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  def best_day
    invoices
      .joins([:invoice_items, :transactions])
      .where(transactions: { result: :success })
      .select('invoices.*,
               sum(invoice_items.unit_price * invoice_items.quantity) as money')
      .group(:id)
      .order('money desc', 'invoices.created_at desc')
      .first
      .formatted_time
  end
end
