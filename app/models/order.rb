class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  enum status: { pending: 0, insurance_approved: 3, cpf_approved: 6, charge_pending: 9, charge_approved: 12 }
  # enum payment_method: { credit_card: 4, pix: 8, boleto: 12 }
  before_save :calculate_price
  validates :contract_period, presence: true
  validates :contract_period, comparison: { greater_than: 0 }, allow_blank: true

  def calculate_price
    equipment_price = equipment.equipment_price
    self.total_price = (((price_percentage * equipment_price) / 100) * contract_period)
  end
end
