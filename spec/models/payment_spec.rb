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
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)
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
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)
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
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)
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
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)
      payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
      allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
      payment = Payment.new(order:, client:, payment_method_id: 1, parcels: 1, invoice_token: nil, status: :paid)

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
                                             fixture_file_upload('spec/support/photo_2.jpg')])
      insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                                product_model: 'iPhone 11', packages: 'Premium', price: 2)
      order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                            client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                            insurance_model: insurance.product_model, price_percentage: insurance.price)
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
end
