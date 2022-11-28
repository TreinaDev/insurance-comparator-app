require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe '#valid?' do
    it 'deve ter a quantidade de parcelas' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month)
      payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.new(order:, client:, payment_method_id: 1, parcels: nil)

      result = payment.valid?

      expect(result).to eq false
    end

    it 'a quantidade de parcelas deve ser mais ou igual a 1' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month)
      payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.new(order:, client:, payment_method_id: 1, parcels: 0)

      result = payment.valid?

      expect(result).to eq false
    end

    it 'deve ter um meio de pagamento' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month)
      allow(PaymentOption).to receive(:find).with(nil).and_return(nil)
      payment = Payment.new(order:, client:, payment_method_id: nil, parcels: 1)

      result = payment.valid?

      expect(result).to eq false
    end

    it 'deve ter o número da nota fiscal se pago' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month)
      payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.new(order:, client:, payment_method_id: 1, parcels: 1, invoice_token: nil, status: :approved)

      result = payment.valid?

      expect(result).to eq false
    end

    it 'parcelas não pode ser maior que a quantidade máxima de parcelas do meio de pagamento' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month)
      payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.new(order:, client:, payment_method_id: 1, parcels: 20)

      result = payment.valid?

      expect(result).to eq false
      expect(payment.errors[:parcels]).to include ' não pode ser maior que o máximo permitido pelo meio de pagamento'
    end
  end

  describe '#request_payment' do
    it 'com sucesso' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, package_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month,
                            insurance_company_id: insurance.insurance_company_id)
      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

      url = "#{Rails.configuration.external_apis['payment_options_api']}/invoices"
      json_dt = Rails.root.join('spec/support/json/invoice.json').read
      fake_response = double('faraday_response', success?: true, body: json_dt)
      params = { invoice: { payment_method_id: payment.payment_method_id, order_id: order.id,
                            registration_number: client.cpf,
                            package_id: order.package_id, insurance_company_id: order.insurance_company_id,
                            voucher: order.voucher_code, parcels: payment.parcels,
                            final_price: order.final_price } }
      allow(Faraday).to receive(:post).with(url, params.to_json,
                                            'Content-Type' => 'application/json').and_return(fake_response)

      response = payment.request_payment

      expect(response['message']).to eq 'Sucesso.'
    end

    it 'sem sucesso' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
      insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price_per_month: 100.00, product_category_id: 1,
                                product_model: 'iPhone 11',
                                coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                                por danificação da tela do aparelho.' }], services: [], product_model_id: 20)
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, package_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                            product_model: insurance.product_model, price: insurance.price_per_month,
                            insurance_company_id: insurance.insurance_company_id)
      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.create!(order:, client:, payment_method_id: 1, parcels: 1)

      url = "#{Rails.configuration.external_apis['payment_options_api']}/invoices"
      json_dt = Rails.root.join('spec/support/json/invoice.json').read
      fake_response = double('faraday_response', success?: false, body: json_dt)
      params = { invoice: { payment_method_id: payment.payment_method_id, order_id: order.id,
                            registration_number: client.cpf,
                            package_id: order.package_id, insurance_company_id: order.insurance_company_id,
                            voucher: order.voucher_code, parcels: payment.parcels,
                            final_price: order.final_price } }
      allow(Faraday).to receive(:post).with(url, params.to_json,
                                            'Content-Type' => 'application/json').and_return(fake_response)

      response = payment.request_payment

      expect(response).to eq nil
    end
  end
end
