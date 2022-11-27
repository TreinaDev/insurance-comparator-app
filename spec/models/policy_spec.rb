require 'rails_helper'

describe Policy do
  context '.find' do
    it 'deve retornar a apólice do pedido' do
      order_id = 1
      json_data = Rails.root.join('spec/support/json/policy.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)

      allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/policies/order/#{order_id}").and_return(fake_response)
      result = Policy.find(order_id)

      expect(result.code).to eq 'NIUGBWSTJ5'
      expect(result.expiration_date).to eq '2023-11-21'
      expect(result.status).to eq 'active'
      expect(result.client_name).to eq 'Maria Alves'
      expect(result.client_registration_number).to eq '99950033340'
      expect(result.client_email).to eq 'mariaalves@email.com'
    end
  end
end
