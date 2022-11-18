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
      payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      Insurance.new(id: 45, insurance_company_id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                    packages: 'Premium', price: 5)
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
      payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      Insurance.new(id: 45, insurance_company_id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                    packages: 'Premium', price: 5)
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
      Insurance.new(id: 45, insurance_company_id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                    packages: 'Premium', price: 5)
      order = Order.new(client:, equipment:, contract_period: 10, insurance_id: 45,
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
end
