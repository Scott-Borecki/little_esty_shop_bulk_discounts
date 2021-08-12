class Item < ApplicationRecord
  enum status: [:disabled, :enabled]

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  delegate :best_day, to: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
end
