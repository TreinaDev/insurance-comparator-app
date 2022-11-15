class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  enum status: { pending: 0, insurance_approved: 3, cpf_approved: 6, cpf_disapproved: 7, charge_pending: 9,
                 charge_approved: 12 }

  def validate_cpf(order)
    response = Faraday.get('http://localhost:5000/api/v1/payment/verifica_cpf')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        if d['cpf'] == order.client.cpf
          order.cpf_disapproved!
          break
        else
          order.cpf_approved!
        end
      end
    end
  end

  def validade_charge(order)
    if order.status == 'cpf_approved'
      order.charge_pending!
    end
  end
end
