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
    payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                                       max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                                       payment_method_status: 0, single_installment_discount: 10)

    Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                  product_model: 'iPhone 11')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                          max_period: 24, min_period: 6, insurance_company_id: 1,
                          insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                          product_category: 'Celular', product_model: 'iphone 11')

    order_result = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                                 max_period: 24, min_period: 6, insurance_company_id: 1,
                                 insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                                 product_category: 'Celular', product_model: 'iphone 11', status: :charge_pending)
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
    payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Cartão',
                                       max_installments: 0, tax_percentage: 7, tax_maximum: 20,
                                       payment_method_status: 0, single_installment_discount: 10)
    Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                  insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                  product_model: 'iPhone 11')
    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                          max_period: 24, min_period: 6, insurance_company_id: 1,
                          insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                          product_category: 'Celular', product_model: 'iphone 11')

    order_result = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, package_name: 'Premium',
                                 max_period: 24, min_period: 6, insurance_company_id: 1,
                                 insurance_name: 'Seguradora 45', price: 10.00, product_category_id: 1,
                                 product_category: 'Celular', product_model: 'iphone 11', status: :cpf_disapproved)

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
