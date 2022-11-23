require 'rails_helper'

RSpec.describe Order, type: :model do
  context '#validate_cpf' do
    it 'e retorna CPF válido' do
      ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                           address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                           birth_date: '29/10/1997')
      equipment = Equipment.create!(client: ana, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                                         max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                                         payment_method_status: 0, single_installment_discount: 10)
      Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                    insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                    product_category: 'Telefone', product_model: 'iPhone 11')
      order = Order.new(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                        price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                        insurance_model: 'iPhone 11', status: :pending)

      json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('https://localhost:5000/api/v1/verifica_cpf/21234567890').and_return(fake_response)

      order.validate_cpf(order.client.cpf)
      result = order.status

      expect(result).to eq 'insurance_company_approval'
    end

    it 'e retorna CPF bloqueado' do
      ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                           address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                           birth_date: '29/10/1997')
      equipment = Equipment.create!(client: ana, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                                         max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                                         payment_method_status: 0, single_installment_discount: 10)
      Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                    insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                    product_category: 'Telefone', product_model: 'iPhone 11')
      order = Order.new(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                        price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                        insurance_model: 'iPhone 11', status: :pending)

      json_data = Rails.root.join('spec/support/json/cpf_disapproved.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('https://localhost:5000/api/v1/verifica_cpf/21234567890').and_return(fake_response)

      order.validate_cpf(order.client.cpf)
      result = order.status

      expect(result).to eq 'cpf_disapproved'
    end
  end

  describe '#total_price' do
    it 'falso quando preço diferente do esperado' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                                         max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                                         payment_method_status: 0, single_installment_discount: 10)

      Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                    insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                    product_category: 'Telefone', product_model: 'iPhone 11')

      order = Order.new(client:, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                        price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                        insurance_model: 'iPhone 11')

      order.save
      expect(order.total_price).to eq 500
    end
  end

  describe '#valid?' do
    context 'presence' do
      it 'período contratado não pode ficar em branco' do
        order = Order.new(contract_period: '')
        order.valid?
        expect(order.errors[:contract_period]).to include 'não pode ficar em branco'
      end
    end
    context 'comparison' do
      it 'período contratado deve ser maior que 0' do
        order = Order.new(contract_period: 0)
        order.valid?
        expect(order.errors[:contract_period]).to include 'deve ser maior que 0'
      end
    end
  end

  context '#post_insurance_app' do
    it 'com sucesso' do
      client = Client.create!(name: 'Bruno Silva', email: 'brunosilva@email.com', password: '12345678', cpf: '11122233344',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                              birth_date: '29/10/1997')
      equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                    purchase_date: '01/11/2022',
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'iPhone 11')
      order = Order.create!(contract_period: 12, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.name,
                            insurance_model: insurance.product_category, price_percentage: insurance.price, policy_id: nil, policy_code: nil)
      url = "#{Rails.configuration.external_apis['payment_options_api']}/invoices"
      json_dt = Rails.root.join('spec/support/json/policy.json').read
      fake_response = double('faraday_response', success?: true, body: json_dt)
      params = { client_name: client.name, client_registration_number: client.cpf,
                 client_email: client.email, policy_period: order.contract_period, order_id: order.id,
                 package_id: order.package_id, insurance_company_id: order.insurance_company_id,
                 equipment_id: equipment.id }
      allow(Faraday).to receive(:post).with(url, params: params.to_json).and_return(fake_response)

      response = order.post_insurance_app

      expect(response['id']).to eq 1
      expect(response['code']).to eq 'D0H5IPUVGK'
      expect(response['client_name']).to eq 'Bruno Silva'
      expect(response['client_registration_number']).to eq '11122233344'
      expect(response['client_email']).to eq 'brunosilva@email.com'
      expect(response['equipment_id']).to eq 1
      expect(response['policy_period']).to eq 12
      expect(response['order_id']).to eq 1
      expect(response['insurance_company_id']).to eq 1
      expect(response['package_id']).to eq 1
      expect(order.status).to eq 'insurance_company_approval'
      expect(order.policy_id).to eq 1
      expect(order.policy_code).to eq 'D0H5IPUVGK'
    end
  end
end
