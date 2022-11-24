require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/order/1' do
    it 'sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 13, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 175.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iphone 11')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')
    order = Order.create(client:, equipment:, contract_period: 10, package_name: 'Premium', max_period: 24, min_period: 6,
                    insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 10.00,
                    product_category_id: 1, product_category:'Celular', product_model: 'iphone 11', contract_period: 12, final_price: 120.00)
    get "/api/v1/orders/1"

    expect(response.status).to eq 200
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body)
    expect(json_response.length).to eq 16
    expect(json_response['code']).to eq 'ABCD-0123456789'
    expect(json_response['package_name']).to eq 'Premium'
    expect(json_response.keys).not_to include('created_at')
    expect(json_response.keys).not_to include('updated_at')
    end
  end
end