class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :order

  enum status: { pending: 0, paid: 5, fail: 7 }
  validates :parcels, numericality: { greater_than_or_equal_to: 1 }

  validates :parcels, :payment_method_id, presence: true
  validates :invoice_token, presence: true, if: :paid?

  # Validação do quantidade de parcelas com a quantidade máxima do método
end
