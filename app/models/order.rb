class Order < ApplicationRecord
  belongs_to :equipment
  enum status: { pending: 0, insurance_approved: 3, cpf_approved: 6, charge_pending: 9, charge_approved: 12 }
end
