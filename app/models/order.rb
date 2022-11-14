class Order < ApplicationRecord
  has_one :equipment
  belongs_to :client
  
  enum status: { pending: 0, insurance_approved: 3, cpf_approved: 6, charge_pending: 9, charge_approved: 12 }
  enum payment_method: { credit_card: 4, pix: 8, boleto: 12 }

end
