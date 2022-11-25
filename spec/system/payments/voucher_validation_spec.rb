require 'rails_helper'

describe 'Cliente insere um cupom de desconto' do
  it 'e o cupom é valido' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 67', price: 2, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    # rubocop:disable Layout/LineLength
    api_url = "#{Rails.configuration.external_apis['payment_options_api']}/insurance_companies/#{insurance.insurance_company_id}/payment_options"
    # rubocop:enable Layout/LineLength
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, product_model_id: 5, price: insurance.price,
                          insurance_company_id: insurance.insurance_company_id)
    voucher = 'ABC123'
    voucher_params = { id: order.product_model_id, price: order.final_price }.to_query
    voucher_url = "#{Rails.configuration.external_apis['payment_options_api']}/promos/#{voucher}/#{voucher_params}"
    json_data = Rails.root.join('spec/support/json/valid_coupon.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(voucher_url).and_return(fake_response)

    login_as(client)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: voucher
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(order)
    expect(page).to have_content 'Cupom inserido com sucesso'
  end

  it 'e o cupom é inválido' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium', insurance_model: 'iPhone 11', status:, voucher_name: nil, voucher: nil)

    allow(payment).to receive(:voucher_validation).and_return(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(@order)
    expect(page).to have_content 'Cupom inválido'
  end

  it 'e o cupom está expirado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                          insurance_model: 'iPhone 11', status:, voucher_name: nil, voucher: nil)

    allow(payment).to receive(:voucher_validation).and_return(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(@order)
    expect(page).to have_content 'Cupom expirado'
  end
end
