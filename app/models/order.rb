class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  has_one :payment, dependent: nil
  before_validation :generate_code, on: :create
  before_save :calculate_price
  validates :contract_period, presence: true
  validates :contract_period, comparison: { greater_than: 0 }, allow_blank: false
  enum status: { pending: 0, insurance_company_approval: 2, insurance_approved: 3, cpf_disapproved: 6,
                 insurance_disapproved: 4, charge_pending: 9, charge_approved: 12, charge_refused: 14 }

  def validate_cpf(client_cpf)
    response = Faraday.get("#{Rails.configuration
      .external_apis['payment_fraud_api']}/blocked_registration_numbers/#{client_cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    if data['blocked'] == 'true'
      cpf_disapproved!
    else
      insurance_company_approval!
    end
  end

  def calculate_price
    self.final_price = price * contract_period
  end

  def update_final_price
    (price * contract_period) - voucher
  end

  def assign_insurance_to_order(insurance)
    assign_product_variables(insurance)
    assign_insurance_variables(insurance)
    assign_period_variables(insurance)
    assign_package_variables(insurance)
  end

  def approve_charge
    self.charge_approved!
    self.activate_policy
  end

  private

  def activate_policy
    external_url = Rails.configuration.external_apis['insurance_api']
    Faraday.post("#{external_url}/policies/#{@order.policy_code}/active")
  end

  def assign_product_variables(insurance)
    self.product_category_id = insurance.product_category_id
    self.product_model = insurance.product_model
  end

  def assign_insurance_variables(insurance)
    self.insurance_name = insurance.insurance_name
    self.insurance_company_id = insurance.insurance_company_id
  end

  def assign_period_variables(insurance)
    self.max_period = insurance.max_period
    self.min_period = insurance.min_period
  end

  def assign_package_variables(insurance)
    self.price = insurance.price_per_month
    self.package_name = insurance.name
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
