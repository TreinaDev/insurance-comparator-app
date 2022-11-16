class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  enum status: { pending: 0, insurance_approved: 3, cpf_disapproved: 6, charge_pending: 9,
                 charge_approved: 12 }

  # rubocop:disable Metrics/MethodLength
  def validate_cpf
    response = Faraday.get('https://mocki.io/v1/ba1a1ec8-8d1d-47a3-aaf3-4ac9fe9c390c')
    return unless response.success?

    data = JSON.parse(response.body)
    data.each do |d|
      if d['cpf'] == client.cpf
        cpf_disapproved!
        break
      else
        charge_pending!
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
