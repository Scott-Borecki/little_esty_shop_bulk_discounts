class Invoice < ApplicationRecord
  scope :paid, -> { joins(:transactions).merge(Transaction.successful) }
  scope :cancelled, -> { where(status: 0) }
  scope :in_progress, -> { where(status: 1) }
  scope :completed, -> { where(status: 2) }

  enum status: { cancelled: 0, 'in progress': 1, completed: 2 }

  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  delegate :full_name, :address, :city_state_zip, to: :customer, prefix: true
  delegate :revenue_discount, :total_discounted_revenue, :total_revenue, to: :invoice_items
  delegate :discounted, to: :invoice_items, prefix: true

  validates :status, presence: true

  def self.top_revenue_day
    paid.joins(:invoice_items)
        .select('invoices.*,
                 SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue')
        .group(:id)
        .order('total_revenue desc', 'invoices.created_at desc')
        .first
        .formatted_date
  end

  def self.incomplete_invoices
    joins(:invoice_items)
      .merge(InvoiceItem.not_shipped)
      .order(created_at: :asc)
      .distinct
  end
end
