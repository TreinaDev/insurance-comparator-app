require 'rails_helper'

describe 'Orders API' do
  describe 'Usuário atualiza status de pagamento e de pedido' do
    context 'POST /api/v1/orders/invoice.order_id/payment_approved' do
      it 'como aprovado' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
          por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)
        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

        params = {
          transaction_registration_number: 'ACSVDLGF934JHDS9'
        }

        post "/api/v1/orders/#{order.id}/payment_approved", params: params

        expect(response).to have_http_status 200
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'success'
        expect(payment.reload.status).to eq 'approved'
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
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

        params = {
          transaction_registration_number: 'ACSVDLGF934JHDS9'
        }
        allow(Order).to receive(:find).with(order.id.to_s).and_raise(ActiveRecord::ActiveRecordError)

        post "/api/v1/orders/#{order.id}/payment_approved", params: params

        expect(response).to have_http_status 500
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Internal server error'
      end

      it 'sem número de transação' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)
        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

        post "/api/v1/orders/#{order.id}/payment_approved"

        expect(response).to have_http_status 412
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'failure'
        expect(json_data['error']).to eq 'Número de Transação não pode ficar em branco'
        expect(payment.reload.status).to eq 'pending'
        expect(order.reload.status).to eq 'charge_pending'
      end

      it 'com número de transação vazio' do
        client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                                address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                                birth_date: '29/10/1997')
        equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                      purchase_date: '01/11/2022',
                                      invoice: fixture_file_upload('spec/support/invoice.png'),
                                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)
        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)
        params = {
          transaction_registration_number: ''
        }

        post "/api/v1/orders/#{order.id}/payment_approved", params: params

        expect(response).to have_http_status 412
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'failure'
        expect(json_data['error']).to eq 'Número de Transação não pode ficar em branco'
        expect(payment.reload.status).to eq 'pending'
        expect(order.reload.status).to eq 'charge_pending'
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
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)
        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

        post "/api/v1/orders/#{order.id}/payment_refused"

        expect(response).to have_http_status 200
        json_data = JSON.parse(response.body)
        expect(json_data['message']).to eq 'success'
        expect(order.reload.status).to eq 'charge_refused'
        expect(payment.reload.status).to eq 'refused'
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
                                               fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
        payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                           tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                           payment_method_id: 1)
        insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                                  insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                                  product_category_id: 1, product_model: 'iphone 11',
                                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
        order = Order.create!(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                              max_period: 24, min_period: 6, insurance_company_id: insurance.id,
                              insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                              product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)

        allow(PaymentOption).to receive(:find).with(1).and_return(payment_method)
        Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)
        allow(Order).to receive(:find).with(order.id.to_s).and_raise(ActiveRecord::ActiveRecordError)

        post "/api/v1/orders/#{order.id}/payment_refused"

        expect(response).to have_http_status 500
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq 'Internal server error'
      end
    end
  end
end
