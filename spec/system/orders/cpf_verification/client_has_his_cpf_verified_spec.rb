require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  it 'e CPF é válido' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    equipment = Equipment.create!(client: ana, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                       tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                       payment_method_id: 1)
    Insurance.new(id: 45, insurance_company_id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                  packages: 'Premium', price: 5)
    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                          insurance_model: 'iPhone 11', status: :pending)

    order_result = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                                 price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                                 insurance_model: 'iPhone 11', status: :charge_pending)
    allow(order).to receive(:validate_cpf).with('21234567890').and_return(order_result)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_content 'iPhone 11'
    expect(page).to have_content 'Apple'
    expect(page).to have_content 'Pagamento em Processamento'
  end

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    equipment = Equipment.create!(client: ana, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                       tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                       payment_method_id: 1)
    Insurance.new(id: 45, insurance_company_id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11',
                  packages: 'Premium', price: 5)
    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                          insurance_model: 'iPhone 11', status: :pending)

    order_result = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                                 price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                                 insurance_model: 'iPhone 11', status: :cpf_disapproved)

    allow(order).to receive(:validate_cpf).with('21234567890').and_return(order_result)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_content 'iPhone 11'
    expect(page).to have_content 'Apple'
    expect(page).to have_content 'CPF Recusado'
  end
end
