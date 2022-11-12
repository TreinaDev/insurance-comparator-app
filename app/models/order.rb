class Order < ApplicationRecord
  belongs_to :equipment
  has_one :payment_method
  
  enum status: { pending: 0, insurance_approved: 3, cpf_approved: 6, charge_pending: 9, charge_approved: 12 }
  enum payment_method: { credit_card: 0, pix: 3, boleto: 6 }
end
