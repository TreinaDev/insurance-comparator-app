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
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 67', price_per_month: 2, product_category_id: 1,
                              product_model: 'iPhone 11',
                              coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência por
                                danificação da tela do aparelho.' }], services: [], product_model_id: 20)

    # rubocop:disable Layout/LineLength
    api_url = "#{Rails.configuration.external_apis['payment_options_api']}/insurance_companies/#{insurance.insurance_company_id}/payment_options"
    # rubocop:enable Layout/LineLength
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category_id, product_model_id: 5,
                          price: insurance.price_per_month,
                          insurance_company_id: insurance.insurance_company_id,
                          insurance_description: insurance.to_json)

    voucher = 'ABC123'
    voucher_params = { product_id: order.product_model_id, price: order.final_price }.to_query

    voucher_url = "#{Rails.configuration.external_apis['payment_fraud_api']}/promos/#{voucher}/?#{voucher_params}"
    json_data = Rails.root.join('spec/support/json/valid_coupon.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(voucher_url).and_return(fake_response)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(order)
    expect(page).to have_content 'Cupom inserido com sucesso'
  end

  it 'e o cupom é inválido' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 67', price_per_month: 2, product_category_id: 1,
                              product_model: 'iPhone 11',
                              coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência por
                                danificação da tela do aparelho.' }], services: [], product_model_id: 20)

    # rubocop:disable Layout/LineLength
    api_url = "#{Rails.configuration.external_apis['payment_options_api']}/insurance_companies/#{insurance.insurance_company_id}/payment_options"
    # rubocop:enable Layout/LineLength
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category_id, product_model_id: 5,
                          price: insurance.price_per_month,
                          insurance_company_id: insurance.insurance_company_id,
                          insurance_description: insurance.to_json)

    voucher = 'ABC123'
    voucher_params = { product_id: order.product_model_id, price: order.final_price }.to_query
    voucher_url = "#{Rails.configuration.external_apis['payment_fraud_api']}/promos/#{voucher}/?#{voucher_params}"
    json_data = Rails.root.join('spec/support/json/invalid_coupon.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(voucher_url).and_return(fake_response)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(order)
    expect(page).to have_content 'Cupom inválido'
    expect(page).not_to have_content 'Cupom inserido com sucesso'
  end

  it 'e o cupom está expirado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')], product_category_id: 1)
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 67', price_per_month: 2, product_category_id: 1,
                              product_model: 'iPhone 11',
                              coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência por
                                danificação da tela do aparelho.' }], services: [], product_model_id: 20)

    # rubocop:disable Layout/LineLength
    api_url = "#{Rails.configuration.external_apis['payment_options_api']}/insurance_companies/#{insurance.insurance_company_id}/payment_options"
    # rubocop:enable Layout/LineLength
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category_id, product_model_id: 5,
                          price: insurance.price_per_month,
                          insurance_company_id: insurance.insurance_company_id,
                          insurance_description: insurance.to_json)

    voucher = 'ABC123'
    voucher_params = { product_id: order.product_model_id, price: order.final_price }.to_query
    voucher_url = "#{Rails.configuration.external_apis['payment_fraud_api']}/promos/#{voucher}/?#{voucher_params}"
    json_data = Rails.root.join('spec/support/json/expired_coupon.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(voucher_url).and_return(fake_response)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(order)
    expect(page).to have_content 'Cupom expirado'
    expect(page).not_to have_content 'Cupom inserido com sucesso'
  end
end
