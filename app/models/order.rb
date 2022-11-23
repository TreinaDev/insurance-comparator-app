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

  def validate_cpf(client_cpf)
    response = Faraday.get("#{Rails.configuration
      .external_apis['validate_cpf_api']}/blocked_registration_numbers/#{client_cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    if data['blocked'] == 'true'
      cpf_disapproved!
    else
      insurance_company_approval!
    end
  end

  def post_insurance_app
    params = { client_name: current_client.name, client_registration_number: current_client.cpf,
               client_email: current_client.email, policy_period: order.contract_period, order_id: order.id,
               package_id: order.package_id, insurance_company_id: order.insurance_company_id,
               equipment_id: equipment.id }
    response = Faraday.post("#{Rails.configuration.external_apis['payment_options_api']}/policies", params)
    data = JSON.parse(response.body)
    @order.update!(policy_id: data['id'], policy_code: data['code'], status: :insurance_company_approval)
    return JSON.parse(response.body) if response.success?
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

  private

  def assign_product_variables(insurance)
    self.product_category_id = insurance.product_category_id
    self.product_category = insurance.product_category
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
    self.price = insurance.price
    self.package_name = insurance.name
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
