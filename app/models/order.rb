class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  before_validation :generate_code, on: :create
  before_save :calculate_price
  validates :contract_period, presence: true
  validates :contract_period, comparison: { greater_than: 0 }, allow_blank: false
  enum status: { pending: 0, insurance_company_approval: 2, insurance_approved: 3, cpf_disapproved: 6,
                 charge_pending: 9, charge_approved: 12 }
  # before_save :validate_cpf

  # def validate_cpf(client_cpf)
  #   response = Faraday.get("https://localhost:5000/api/v1/verifica_cpf/#{client_cpf}")
  #   return unless response.success?

  #   data = JSON.parse(response.body)
  #   if data['blocked'] == 'true'
  #     cpf_disapproved!
  #   else
  #     insurance_company_approval!
  #   end
  # end

  def calculate_price
    self.final_price = price * contract_period
  end

  def update_final_price
   (price * contract_period) - voucher
  end

  private
  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
