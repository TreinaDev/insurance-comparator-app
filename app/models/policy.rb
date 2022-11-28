class Policy
  attr_accessor :id, :code, :status, :client_name, :client_registration_number,
                :client_email, :equipment_id, :purchase_date, :policy_period,
                :expiration_date, :package_id, :order_id, :insurance_company_id, :file_url

  def initialize(id:, code:, status:, client_name:, client_registration_number:, client_email:, equipment_id:,
                 purchase_date:, policy_period:, expiration_date:, package_id:, order_id:, insurance_company_id:,
                 file_url:)
    @id = id
    @code = code
    @status = status
    @client_name = client_name
    @client_registration_number = client_registration_number
    @client_email = client_email
    @equipment_id = equipment_id
    @purchase_date = purchase_date
    @policy_period = policy_period
    @expiration_date = expiration_date
    @package_id = package_id
    @order_id = order_id
    @insurance_company_id = insurance_company_id
    @file_url = file_url
  end

  def self.find(order_id)
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/policies/order/#{order_id}")
    return unless response.status == 200

    data = JSON.parse(response.body)
    Policy.new(id: data['id'], code: data['code'], status: data['status'],
               client_name: data['client_name'],
               client_registration_number: data['client_registration_number'],
               client_email: data['client_email'], equipment_id: data['equipment_id'],
               purchase_date: data['purchase_date'], policy_period: data['policy_period'],
               expiration_date: data['expiration_date'], package_id: data['package_id'],
               order_id: data['order_id'], insurance_company_id: data['insurance_company_id'],
               file_url: data['file_url'])
  end

  def self.cancel(policy_code, order_id)
    @order = Order.find(order_id)
    response = Faraday.post("#{Rails.configuration.external_apis['insurance_api']}/policies/#{policy_code}/canceled")
    return unless response.status == 200

    data = JSON.parse(response.body)
    Policy.new(id: data['id'], code: data['code'], status: data['status'],
               client_name: data['client_name'],
               client_registration_number: data['client_registration_number'],
               client_email: data['client_email'], equipment_id: data['equipment_id'],
               purchase_date: data['purchase_date'], policy_period: data['policy_period'],
               expiration_date: data['expiration_date'], package_id: data['package_id'],
               order_id: data['order_id'], insurance_company_id: data['insurance_company_id'],
               file_url: data['file_url'])
  end
end
