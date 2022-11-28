require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  it 'e CPF é válido' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    equipment = Equipment.create!(client: ana, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                       tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                       payment_method_id: 1)

    Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                  insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                  product_model: 'iPhone 11', product_model_id: 1,
                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                  por danificação da tela do aparelho.' }], services: [])

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
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    equipment = Equipment.create!(client: ana, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    payment_method = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                       tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                       payment_method_id: 1)

    Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                  insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                  product_model: 'iPhone 11', product_model_id: 1,
                  coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência por
                                danificação da tela do aparelho.' }], services: [])

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
