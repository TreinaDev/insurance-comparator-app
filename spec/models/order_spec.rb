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
      Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                    insurance_company_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                    product_model: 'iPhone 11', product_model_id: 1,
                    coverages: 'Furto', services: '12')
      
      PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                        max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                        payment_method_status: 0, single_installment_discount: 10)
     
      order = Order.new(client: ana, equipment:, contract_period: 10, insurance_company_id: 45,
                        price: 10.00, final_price: 100, insurance_name: 'Seguradora 45',
                        package_name: 'Premium', product_category_id: 2, product_category: 'iPhone 11',
                        status: :pending)

      json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      cpf = '21234567890'
      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis['validate_cpf_api']}/blocked_registration_numbers/#{cpf}")
        .and_return(fake_response)

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

      Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                    insurance_company_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                    product_model: 'iPhone 11', product_model_id: 1, coverages: 'Furto', services: '12')

      PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                        max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                        payment_method_status: 0, single_installment_discount: 10)
      
      order = Order.new(id: 2, client: ana, equipment:, min_period: 1, max_period: 24,
                        contract_period: 10, insurance_company_id: 45, price: 5, insurance_name: 'Seguradora 45',
                        package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                        product_model: 'iPhone 11', status: :pending)
      json_data = Rails.root.join('spec/support/json/cpf_disapproved.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      cpf = '21234567890'
      allow(Faraday).to receive(:get)
        .with("#{Rails.configuration.external_apis['validate_cpf_api']}/blocked_registration_numbers/#{cpf}")
        .and_return(fake_response)

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

      Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                    insurance_company_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                    product_model: 'iPhone 11', product_model_id: 1, coverages: 'Furto', services: '12')
     
      order = Order.new(client:, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                        max_period: 24, min_period: 6, insurance_company_id: 1,
                        insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                        product_category: 'Celular', product_model: 'iphone 11')

      order.save
      expect(order.final_price).to eq 100
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
end
