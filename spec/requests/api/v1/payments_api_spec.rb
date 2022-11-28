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
      insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6,
                                insurance_company_id: 45, insurance_name: 'Seguradora 45',
                                price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11', product_model_id: 1,
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [])
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month,
                            insurance_company_id: 45)

      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(45, 1).and_return(payment_option)
      Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

      get "/api/v1/payments/#{order.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('pending')
      expect(json_response['order_id']).to eq(1)
      expect(json_response['client']['cpf']).to eq('21234567890')
      expect(json_response['payment_method_id']).to eq(1)
      expect(json_response['parcels']).to eq(1)
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
end
