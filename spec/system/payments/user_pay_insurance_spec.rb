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
    insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                              product_model: 'iPhone 11', packages: 'Premium', price: 50)
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, price_percentage: 2, equipment:,
                          client:, insurance_id: insurance.id)

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
    insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                              product_model: 'iPhone 11', packages: 'Premium', price: 2)
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                          client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                          insurance_model: insurance.product_model, price_percentage: insurance.price)

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
    expect(page).to have_content 'Período contratado: 9 meses'
    expect(page).to have_content 'Valor do Seguro: R$ 215,00'
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
    insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                              product_model: 'iPhone 11', packages: 'Premium', price: 2)
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                          client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                          insurance_model: insurance.product_model, price_percentage: insurance.price)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    select 'Boleto - Roxinho', from: 'Meio de Pagamento'
    fill_in 'Parcelas', with: '1'
    click_on 'Salvar'

    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Seu pagamento foi salvo com sucesso!'
    expect(page).to have_content 'Status: Pagamento em Processamento'
    expect(page).to have_content 'Meio de Pagamento: 2' # Mudar pra nome e tipo formatado
    expect(page).to have_content 'Parcelas: 1x'
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
    insurance = Insurance.new(id: 67, insurance_company_id: 67, insurance_name: 'Seguradora 67',
                              product_model: 'iPhone 11', packages: 'Premium', price: 2)
    api_url = Rails.configuration.external_apis['payment_options_api'].to_s
    json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:, insurance_id: insurance.id,
                          client:, insurance_name: insurance.insurance_name, packages: insurance.packages,
                          insurance_model: insurance.product_model, price_percentage: insurance.price)

    login_as(client)
    visit order_path(order.id)
    click_on 'Pagar'
    fill_in 'Parcelas', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível salvar o seu pagamento.'
  end
end
