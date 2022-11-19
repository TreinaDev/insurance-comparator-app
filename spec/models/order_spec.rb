require 'rails_helper'

RSpec.describe Order, type: :model do
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
      Insurance.new(id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                    packages: 'Premium', price: 5)
      order = Order.new(client:, equipment:, payment_method:, contract_period: 10, insurance_company_id: 45,
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
