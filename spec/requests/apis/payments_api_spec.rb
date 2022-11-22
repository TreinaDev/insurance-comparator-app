require 'rails_helper'

describe 'Payment API' do
  context 'GET /api/v1/payments/:id' do
    it 'com sucesso' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

      get "/api/v1/payments/#{payment.order_id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('pending')
      expect(json_response['order_id']).to eq(1)
      expect(json_response['client']['cpf']).to eq('21234567890')
      # expect(json_response['order']['insurance_company_id']).to eq(67)
      expect(json_response['payment_method_id']).to eq(1)
      expect(json_response['parcels']).to eq(1)
      expect(json_response['order']['insurance_id']).to eq(67)
      # expect(json_response['total_price']).to eq(insurance.price)
    end

    it 'e não encontra pagamento' do
      get '/api/v1/payments/50'

      expect(response).to have_http_status 404
    end

    it 'e ocorre erro interno' do
      allow(Payment).to receive(:find).and_raise(ActiveRecord::QueryAborted)

      get '/api/v1/payments/1'

      expect(response).to have_http_status(500)
    end
  end

  context 'PATCH /api/v1/payments/:id' do
    it 'com sucesso e status de falha' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)
      payment_params = { payment: { status: :fail } }

      patch '/api/v1/payments/1', params: payment_params

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('fail')
      expect(json_response['order_id']).to eq(1)
      expect(json_response['client']['cpf']).to eq('21234567890')
      # expect(json_response['order']['insurance_company_id']).to eq(67)
      expect(json_response['payment_method_id']).to eq(1)
      expect(json_response['parcels']).to eq(1)
      expect(json_response['order']['insurance_id']).to eq(67)
      # expect(json_response['total_price']).to eq(insurance.price)
    end

    it 'com sucesso e status de pago' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)
      payment_params = { payment: { status: :paid, invoice_token: 'USAIUE55D85A' } }

      patch '/api/v1/payments/1', params: payment_params

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('paid')
      expect(json_response['invoice_token']).to eq('USAIUE55D85A')
      expect(json_response['order_id']).to eq(1)
      expect(json_response['client']['cpf']).to eq('21234567890')
      # expect(json_response['order']['insurance_company_id']).to eq(67)
      expect(json_response['payment_method_id']).to eq(1)
      expect(json_response['parcels']).to eq(1)
      expect(json_response['order']['insurance_id']).to eq(67)
      # expect(json_response['final_price']).to eq(order.final_price)
    end

    it 'com dados inválidos' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)
      payment_params = { payment: { status: :paid } }

      patch '/api/v1/payments/1', params: payment_params

      expect(response).to have_http_status(412)
    end
  end

  context 'POST /api/v1/payments/:id' do
    it 'com sucesso' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 1, insurance_company_id: 1, insurance_name: 'Seguradora 1',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

      url = "#{Rails.configuration.external_apis['payment_options_api'].to_s}/invoices"
      json_dt = Rails.root.join('spec/support/json/invoice.json').read
      fake_response = double('faraday_response', success?: true, body: json_dt)
      params = {invoice: {payment_method_id: 1, order_id: 1, registration_number: '21234567890', package_id: 1,
                          insurance_company_id:1}}
      allow(Faraday).to receive(:post).with(url, params: params.to_json).and_return(fake_response)

      response = payment.post_on_external_api

      expect(response["id"]).to eq 9
      expect(response["insurance_company_id"]).to eq 1
      expect(response["order_id"]).to eq 1
      expect(response["package_id"]).to eq 1
      expect(response["payment_method_id"]).to eq 2
      expect(response["registration_number"]).to eq "21234567890"
      expect(response["status"]).to eq "pending"
      expect(response["token"]).to eq "CWTGUUWXJUMS4ABQYGPV"
    end
  end
end
