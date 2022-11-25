require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'se estiver autenticado' do
    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                              product_model: 'iPhone 11', product_model_id: 20,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])

    allow(Insurance).to receive(:find).with('20', '45').and_return(insurance)

    visit new_product_insurance_order_path(insurance.product_model_id, insurance.id)

    expect(current_path).to eq new_client_session_path
  end

  it 'se tiver um dispositivo cadastrado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    insurance = Insurance.new(id: 44, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                              product_model: 'iPhone 11', product_model_id: 20,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])

    allow(Insurance).to receive(:find).with('20', '44').and_return(insurance)

    login_as(client)
    visit new_product_insurance_order_path(insurance.product_model_id, insurance.id)

    expect(current_path).to eq new_equipment_path
    expect(page).to have_content 'É necessário cadastrar um dispositivo para contratar o seguro'
  end

  it 'a partir da página de detalhes do pacote' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple',
                      equipment_price: 10_199, purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    Equipment.create!(client:, name: 'Samsung SX', brand: 'Samsung',
                      equipment_price: 10_199, purchase_date: '28/09/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    json_data3 = Rails.root.join('spec/support/json/product_iphone.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1")
                                   .and_return(fake_response3)

    json_data4 = Rails.root.join('spec/support/json/insurances.json').read
    fake_response4 = double('faraday_response', status: 200, body: json_data4)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1/packages")
                                   .and_return(fake_response4)

    json_data4 = Rails.root.join('spec/support/json/insurance.json').read
    fake_response4 = double('faraday_response', success?: true, body: json_data4)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1/packages/4")
                                   .and_return(fake_response4)

    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['payment_fraud_api']}/blocked_registration_numbers/21234567890")
      .and_return(fake_response)

    login_as(client)
    visit product_insurance_path(1, 4)
    click_link 'Contratar'

    expect(current_path).to eq new_product_insurance_order_path(1, 4)
    expect(page).to have_content 'Aquisição do Seguro'
    expect(page).to have_content 'Super Econômico'
    expect(page).to have_content 'Nome da Seguradora: Anjo Seguradora'
    expect(page).to have_content 'Modelo do Produto: iPhone 12'
    expect(page).to have_select 'Dispositivo', text: 'iphone 11'
    expect(page).to have_select 'Dispositivo', text: 'Samsung SX'
    expect(page).to have_select 'Período de contratação', maximum: 24
    expect(page).to have_button 'Contratar Pacote'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000, purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    json_data3 = Rails.root.join('spec/support/json/product.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1")
                                   .and_return(fake_response3)

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                              product_model: 'iPhone 11', product_model_id: 1,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])

    allow(Insurance).to receive(:find).with('1', '45').and_return(insurance)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')
    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    cpf = '21234567890'
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['payment_fraud_api']}/blocked_registration_numbers/#{cpf}")
      .and_return(fake_response)

    login_as(client)
    visit product_insurance_path(insurance.product_model_id, insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    select 7, from: 'Período de contratação'
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Seu pedido está em análise pela seguradora'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Período de contratação: 7 meses'
    expect(page).to have_content 'Valor do Seguro a/m: R$ 100,00'
    expect(page).to have_content 'Valor final sem desconto: R$ 700,00'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Status: Aguardando Aprovação da Seguradora'
  end
  it 'tenta contratar sem selecionar as opções' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000, purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    json_data3 = Rails.root.join('spec/support/json/product.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1")
                                   .and_return(fake_response3)

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                              product_model: 'iPhone 11', product_model_id: 1,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])

    allow(Insurance).to receive(:find).with('1', '45').and_return(insurance)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')
    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    cpf = '21234567890'
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['payment_fraud_api']}/blocked_registration_numbers/#{cpf}")
      .and_return(fake_response)

    login_as(client)
    visit product_insurance_path(insurance.product_model_id, insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Não foi possível cadastrar o pedido'
    expect(page).to have_content 'Por favor verifique os erros abaixo'
    expect(page).to have_content 'Período de contratação não pode ficar em branco'
    expect(page).not_to have_content 'Seu pedido está em análise pela seguradora'
  end

  it 'com dados inválidos' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    json_data3 = Rails.root.join('spec/support/json/product.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1")
                                   .and_return(fake_response3)

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 100.00, product_category_id: 1,
                              product_model: 'iPhone 11', product_model_id: 1,
                              coberturas: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])

    allow(Insurance).to receive(:find).with('1', '45').and_return(insurance)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')
    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    cpf = '21234567890'
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['payment_fraud_api']}/blocked_registration_numbers/#{cpf}")
      .and_return(fake_response)

    login_as(client)
    visit product_insurance_path(insurance.product_model_id, insurance.id)
    click_link 'Contratar'
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Por favor verifique os erros abaixo'
    expect(page).to have_content 'Período de contratação não pode ficar em branco'
    expect(page).to have_content 'Dispositivo é obrigatório(a)'
    expect(page).not_to have_content 'Seu pedido está em análise pela seguradora'
  end
end
