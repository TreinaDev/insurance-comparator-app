require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders/1' do
    it 'sucesso' do
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
                                coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [])

      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')
      Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                    contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                    package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                    voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                    product_model: 'iPhone 11', status: :insurance_company_approval,
                    package_id: insurance.id)

      get '/api/v1/orders/1'

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 24
      expect(json_response['code']).to eq 'ABCD-0123456789'
      expect(json_response['package_name']).to eq 'Premium'
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end
  end

  it 'falha se o pedido não é encontrado' do
    get '/api/v1/orders/99999999999999999999999999999999999'

    expect(response.status).to eq 404
  end
end

describe 'Order API' do
  context 'POST /api/v1/orders/:id/insurance_approved' do
    it 'com sucesso e pedido é aprovado pela seguradora' do
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
                                coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [])

      order = Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                            contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                            package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                            voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                            product_model: 'iPhone 11', status: 0,
                            package_id: insurance.id)

      order_params = { body: { order: { status: ':insurance_approved', policy_id: 1, policy_code: 'ABC1234567' } } }

      post "/api/v1/orders/#{order.id}/insurance_approved", params: order_params

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('insurance_approved')
      expect(json_response['policy_id']).to eq 1
      expect(json_response['policy_code']).to eq 'ABC1234567'
    end

    it 'com sucesso e pedido é recusado pela seguradora' do
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
                                coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [])

      order = Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                            contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                            package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                            voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                            product_model: 'iPhone 11', status: 0,
                            package_id: insurance.id)

      order_params = { body: { order: { status: ':insurance_disapproved', policy_id: 1, policy_code: 'ABC1234567' } } }

      post "/api/v1/orders/#{order.id}/insurance_disapproved", params: order_params

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('insurance_disapproved')
      expect(json_response['policy_id']).to eq 1
      expect(json_response['policy_code']).to eq 'ABC1234567'
    end
  end
end
