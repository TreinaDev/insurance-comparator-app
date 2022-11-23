require 'rails_helper'

describe 'Usuário efetua pagamento' do
  it 'a partir da página de acompanhamento do pedito' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 10_199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price)

    login_as(client)
    visit order_path(order.id)

    expect(page).to have_content 'Status: Pedido Aprovado'
    expect(page).to have_link 'Pagar'
  end

  it 'e vê formulário' do
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
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'

    expect(page).to have_content 'Emissão de Pagamento'
    expect(page).to have_content 'Cartão de Crédito - Laranja'
    expect(page).to have_content 'Taxa por Cobrança: 5%'
    expect(page).to have_content 'Taxa Máxima: R$ 100,00'
    expect(page).to have_content 'Quantidade máxima de parcelas: 12x'
    expect(page).to have_content 'Desconto à vista: 1%'
    expect(page).to have_content 'Boleto - Roxinho'
    expect(page).to have_content 'Taxa por Cobrança: 1%'
    expect(page).to have_content 'Taxa Máxima: R$ 5,00'
    expect(page).to have_content 'Quantidade máxima de parcelas: 1x'
    expect(page).to have_content 'Desconto à vista: 1%'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 67'
    expect(page).to have_content 'Período de contratação: 9 meses'
    expect(page).to have_content 'Valor do Seguro: R$ 18,00'
    expect(page).to have_link 'iPhone 11', href: equipment_path(equipment)
    expect(page).to have_select 'Meio de Pagamento', text: 'Cartão de Crédito - Laranja'
    expect(page).to have_select 'Meio de Pagamento', text: 'Boleto - Roxinho'
    expect(page).to have_button 'Salvar'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    payment_options = []
    payment_options << PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                         tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                         payment_method_id: 1)
    payment_options << PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
    allow(PaymentOption).to receive(:all).and_return(payment_options)
    payment_option = PaymentOption.new(name: 'Laranja', payment_type: 'Cartão de Crédito', tax_percentage: 5,
                                       tax_maximum: 100, max_parcels: 12, single_parcel_discount: 1,
                                       payment_method_id: 1)
    allow(PaymentOption).to receive(:find).with(1).and_return(payment_option)
    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price)

    url = "#{Rails.configuration.external_apis['payment_options_api']}/invoices"
    json_dt = Rails.root.join('spec/support/json/invoice.json').read
    fake_response = double('faraday_response', success?: true, body: json_dt)
    params = { invoice: { payment_method_id: 1, order_id: order.id, registration_number: client.cpf,
                          package_id: 1, insurance_company_id: 1, voucher: '', parcels: 0,
                          final_price: order.final_price }}
    allow(Faraday).to receive(:post).with(url, params.to_json, "Content-Type" => "application/json").and_return(fake_response)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    select 'Cartão de Crédito - Laranja', from: 'Meio de Pagamento'
    fill_in 'Parcelas', with: '1'
    click_on 'Salvar'

    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Seu pagamento foi salvo com sucesso!'
    expect(page).to have_content 'Status: Pagamento em Processamento'
    expect(page).to have_content 'Meio de Pagamento: Cartão de Crédito - Laranja'
    expect(page).to have_content 'Parcelas: 1x'
    expect(page).not_to have_button 'Pagar'
  end

  it 'com dados inválidos' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
    payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                       max_parcels: 1, single_parcel_discount: 1,
                                       payment_method_id: 2)
    allow(PaymentOption).to receive(:find).with(2).and_return(payment_option)
    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    select 'Boleto - Roxinho', from: 'Meio de Pagamento'
    fill_in 'Parcelas', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível salvar o seu pagamento.'
    expect(page).to have_content 'Parcelas não pode ficar em branco'
  end

  it 'com número de parcelas maior que o permitido pelo meio de pagamento' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1199,
                                  purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url).and_return(fake_response)
    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price)

    payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                       max_parcels: 1, single_parcel_discount: 1,
                                       payment_method_id: 2)
    allow(PaymentOption).to receive(:find).with(2).and_return(payment_option)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    select 'Boleto - Roxinho', from: 'Meio de Pagamento'
    fill_in 'Parcelas', with: '20'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível salvar o seu pagamento.'
    expect(page).to have_content 'Parcelas não pode ser maior que o máximo permitido pelo meio de pagamento'
  end
end
