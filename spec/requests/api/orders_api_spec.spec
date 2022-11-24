require 'rails_helper'

describe 'Order API' do
  context 'POST /api/v1/orders/:id/insurance_company_approval' do
    it 'com sucesso' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6,
                                insurance_company_id: 45, insurance_name: 'Seguradora 45',
                                price: 100.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'iPhone 11')
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :pending, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.name,
                            insurance_model: insurance.product_category, price_percentage: insurance.price)
      params = { policy: { client_name: client.name, client_registration_number: client.cpf,
                           client_email: client.email, policy_period: order.contract_period, order_id: order.id,
                           package_id: 1,
                           insurance_company_id: order.insurance_company_id, equipment_id: equipment.id } }

      post "/api/v1/orders/#{orde.id}/insurance_company_approval", params:
    end
  end
end
