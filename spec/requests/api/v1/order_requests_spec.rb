require 'rails_helper'

describe 'Orders API' do
  describe 'Usuário atualiza status de pagamento de um pedido' do
    context 'POST /api/v1/orders/invoice.order_id/payment_approved' do
      it 'como pagamento bem-sucedido' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')])
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                                  product_category: 'Telefone', product_model: 'iPhone 11')
        order = Order.create!(client: client, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        post "/api/v1/orders/#{order.id}/payment_approved"

        expect(response).to have_http_status 200
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'success'
        expect(order.reload.status).to eq 'charge_approved'
      end

      it 'e a aplicação recebe um ID Inválido' do
        post '/api/v1/orders/ABLUBLUBLBUBLGLELGLEGLEGLE/payment_approved'

        expect(response).to have_http_status 404
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Invalid ID'
      end

      it 'e ocorre um erro interno' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')])
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                                  product_category: 'Telefone', product_model: 'iPhone 11')
        order = Order.create!(client: client, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        allow(Order).to receive(:find).with(order.id.to_s).and_raise(ActiveRecord::ActiveRecordError)
        post "/api/v1/orders/#{order.id}/payment_approved"

        expect(response).to have_http_status 500
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Internal server error'
      end
    end

    context 'POST /api/v1/orders/invoice.order_id/payment_refused' do
      it 'como pagamento recusado' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')])
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                                  product_category: 'Telefone', product_model: 'iPhone 11')
        order = Order.create!(client: client, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        post "/api/v1/orders/#{order.id}/payment_refused"

        expect(response).to have_http_status 200
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'success'
        expect(order.reload.status).to eq 'charge_refused'
      end

      it 'e a aplicação recebe um ID Inválido' do
        post '/api/v1/orders/ABLUBLUBLBUBLGLELGLEGLEGLE/payment_refused'

        expect(response).to have_http_status 404
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Invalid ID'
      end

      it 'e ocorre um erro interno' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')])
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                                  product_category: 'Telefone', product_model: 'iPhone 11')
        order = Order.create!(client: client, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        allow(Order).to receive(:find).with(order.id.to_s).and_raise(ActiveRecord::ActiveRecordError)
        post "/api/v1/orders/#{order.id}/payment_refused"

        expect(response).to have_http_status 500
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Internal server error'
      end
    end
  end
end
