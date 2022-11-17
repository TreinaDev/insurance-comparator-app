class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  enum status: { pending: 0, insurance_approved: 3, cpf_disapproved: 6, charge_pending: 9,
                 charge_approved: 12 }

  def validate_cpf(client_cpf)
    response = Faraday.get("https://localhost:5000/api/v1/verifica_cpf/#{client_cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    if data['blocked'] == 'true'
      cpf_disapproved!
    else
      charge_pending!
    end
  end
end
