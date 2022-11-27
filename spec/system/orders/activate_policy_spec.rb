require 'rails_helper'

describe 'posta ativação de apólice para seguradora' do
  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    insurance = Insurance.new(id: 13, name: 'Premium', max_period: 24, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 175.00, product_category_id: 1,
                              product_model: 'iphone 11', product_model_id: 1,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])
    order = Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                          contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                          package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                          voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                          product_model: 'iPhone 11', status: 9,
                          package_id: insurance.id, policy_id: 3, policy_code: 'GHI1234567')

    url = "http://localhost:3000/api/v1/policies/#{order.policy_code}/active"
    fake_response = double('faraday_response', status: 200)
    allow(Faraday).to receive(:post).with(url).and_return(fake_response)

    order.approve_charge

    expect(order.status).to eq 'charge_approved'
  end
end
