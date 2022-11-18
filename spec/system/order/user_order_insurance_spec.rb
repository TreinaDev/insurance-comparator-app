require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'se estiver autenticado' do
    insurance = Insurance.new(id: 76, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                              product_model: 'iPhone 11')

    allow(Insurance).to receive(:find).with('76').and_return(insurance)

    visit new_insurance_order_path(insurance.id)

    expect(current_path).to eq new_client_session_path
  end

  it 'se tiver um dispositivo cadastrado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    insurance = Insurance.new(id: 44, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                            insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                            product_model: 'iPhone 11')


    allow(Insurance).to receive(:find).with('44').and_return(insurance)

    login_as(client)
    visit new_insurance_order_path(insurance.id)

    expect(current_path).to eq new_equipment_path
    expect(page).to have_content 'É necessário cadastrar um dispositivo para contratar o seguro'
  end

  it 'a partir da página de detalhes do pacote' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 10_199,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    Equipment.create!(client:, name: 'Samsung SX', brand: 'Samsung', equipment_price: 10_199,
                      purchase_date: '28/09/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    insurance = Insurance.new(id: 67, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 67', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                              product_model: 'iPhone 11')

    allow(Insurance).to receive(:find).with('67').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'

    expect(current_path).to eq new_insurance_order_path(insurance.id)
    expect(page).to have_content 'Aquisição do Seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 67'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_select 'Dispositivo', text: 'iphone 11'
    expect(page).to have_select 'Dispositivo', text: 'Samsung SX'
    expect(page).to have_field 'Período de contratação em meses', type: :number
    expect(page).to have_button 'Contratar Pacote'

    # expect(current_path).to eq new_insurance_order_path(insurance.id)
    # expect(page).to have_content 'Aquisição do Seguro'
    # expect(page).to have_content 'Nome da Seguradora: Seguradora 67'
    # expect(page).to have_content 'Tipo de Pacote: Premium'
    # expect(page).to have_content 'Modelo do Produto: iPhone 11'
    # expect(page).to have_content 'Porcentagem do Seguro: 50 %'
    # expect(page).to have_select 'Dispositivo', text: 'iphone 11'
    # expect(page).to have_select 'Dispositivo', text: 'Samsung SX'
    # expect(page).to have_field 'Período de contratação em meses', type: :number
    # expect(page).to have_button 'Contratar Pacote'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                              product_model: 'iPhone 11')

    allow(Insurance).to receive(:find).with('45').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    fill_in 'Período de contratação em meses', with: 7
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Seu pedido está em análise pela seguradora'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Período contratado: 7 meses'
    # expect(page).to have_content 'Valor do Seguro: R$ 700,00'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Dispositivo: iphone 11'
    expect(page).to have_content 'Status: Aguardando Aprovação da Seguradora'
  
    # expect(page).to have_content 'Seu pedido está em análise pela seguradora'
    # expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    # expect(page).to have_content 'Modelo do Produto: iPhone 11'
    # expect(page).to have_content 'Período contratado: 7 meses'
    # expect(page).to have_content 'Porcentagem do Seguro: 2.5%'
    # expect(page).to have_content 'Valor do Seguro: R$ 175,00'
    # expect(page).to have_content 'Tipo de Pacote: Premium'
    # expect(page).to have_content 'Dispositivo: iphone 11'
    # expect(page).to have_content 'Status: Aguardando Aprovação da Seguradora'
  end

  it 'e deixa campo obrigatório em branco' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                              product_model: 'iPhone 11')

    allow(Insurance).to receive(:find).with('45').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Não foi possível cadastrar o pedido'
    expect(page).to have_content 'Por favor verifique o erro abaixo'
    expect(page).to have_content 'Período contratado não pode ficar em branco'
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

    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 18, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                              product_model: 'iPhone 11')

    allow(Insurance).to receive(:find).with('45').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    fill_in 'Período de contratação em meses', with: -5
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Período contratado deve ser maior que 0'
    expect(page).not_to have_content 'Seu pedido está em análise pela seguradora'
  end
end
