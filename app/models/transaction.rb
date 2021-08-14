class Transaction < ApplicationRecord
  scope :successful, -> { where(result: :success) }

  enum result: [:failed, :success]

  belongs_to :invoice

  validates :credit_card_number, presence: true,
                                 numericality: true,
                                 length: { in: 15..16 }
  validates :credit_card_expiration_date, presence: true,
                                          numericality: true,
                                          length: { is: 4 }
  validates :result, presence: true
end
