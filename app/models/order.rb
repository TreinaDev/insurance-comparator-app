class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  has_many :payments, dependent: nil
  before_save :calculate_price
  validates :contract_period, presence: true
  validates :contract_period, comparison: { greater_than: 0 }, allow_blank: true
  enum status: { pending: 0, insurance_company_approval: 2, insurance_approved: 3, cpf_disapproved: 6,
                 charge_pending: 9, charge_approved: 12 }
  # enum payment_method: { credit_card: 4, pix: 8, boleto: 12 }

  def validate_cpf(client_cpf)
    response = Faraday.get("https://localhost:5000/api/v1/verifica_cpf/#{client_cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    if data['blocked'] == 'true'
      cpf_disapproved!
    else
      insurance_company_approval!
    end
  end

  def calculate_price
    equipment_price = equipment.equipment_price
    self.total_price = (((price_percentage * equipment_price) / 100) * contract_period)
  end
end
