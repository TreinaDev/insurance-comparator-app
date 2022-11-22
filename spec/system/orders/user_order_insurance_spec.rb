require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'se estiver autenticado' do
    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 175.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iPhone 11')
    allow(Insurance).to receive(:find).with('76').and_return(insurance)

    visit new_insurance_order_path(insurance.id)

    expect(current_path).to eq new_client_session_path
  end

  it 'se tiver um dispositivo cadastrado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    insurance = Insurance.new(id: 44, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 175.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iPhone 11')
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
    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 10.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iPhone 11')
    allow(Insurance).to receive(:find).with('45').and_return(insurance)
    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/blocked_registration_numbers/21234567890').and_return(fake_response)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'

    expect(current_path).to eq new_insurance_order_path(insurance.id)
    expect(page).to have_content 'Aquisição do Seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    # expect(page).to have_content 'Valor do Seguro a/m: R$ 10,00'
    expect(page).to have_select 'Dispositivo', text: 'iphone 11'
    expect(page).to have_select 'Dispositivo', text: 'Samsung SX'
    expect(page).to have_select "Período de contratação", maximum: insurance.max_period
    expect(page).to have_button 'Contratar Pacote'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:client, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 10.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iphone 11')
    
    allow(Insurance).to receive(:find).with('45').and_return(insurance)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')

    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/blocked_registration_numbers/21234567890').and_return(fake_response)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    select 7, from: 'Período de contratação'
    click_button 'Contratar Pacote'
 
    expect(page).to have_content 'Seu pedido está em análise pela seguradora'
    # expect(page).to have_content 'Código do pedido: ABCD-0123456789'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Categoria do Produto: Celular'
    expect(page).to have_content 'Modelo do Produto: iphone 11'
    expect(page).to have_content 'Período de contratação: 7 meses'
    expect(page).to have_content 'Valor do Seguro a/m: R$ 10,00'
    expect(page).to have_content 'Valor final sem desconto: R$ 70,00'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Status: Aguardando Aprovação da Seguradora'
  end
  it 'com dados inválidos' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 13, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 175.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iphone 11')  
                                               
    allow(Insurance).to receive(:find).with('13').and_return(insurance)
    json_data = Rails.root.join('spec/support/json/cpf_approved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/blocked_registration_numbers/21234567890').and_return(fake_response)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    click_button 'Contratar Pacote'
    
    # expect(flash[:alert]).to match 'Período de contratação não pode ficar em branco'
    # expect(page).to have_content 'Não foi possível cadastrar o pedido'
    expect(page).to have_content 'Por favor verifique os erros abaixo'
    expect(page).to have_content 'Período de contratação não pode ficar em branco'
    expect(page).to have_content 'Dispositivo é obrigatório(a)'
    expect(page).not_to have_content 'Seu pedido está em análise pela seguradora'
  end
  it 'o cpf está bloqueado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:client, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                              insurance_company_id: 1, insurance_name: 'Seguradora 45', price: 10.00,
                              product_category_id: 1, product_category:'Celular', product_model: 'iphone 11')
    
    allow(Insurance).to receive(:find).with('45').and_return(insurance)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD-0123456789')

    json_data = Rails.root.join('spec/support/json/cpf_disapproved.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/blocked_registration_numbers/21234567890').and_return(fake_response)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    select 7, from: 'Período de contratação'
    click_button 'Contratar Pacote'
    
    expect(page).to have_content 'Não foi possível cadastrar o pedido'
  end
end
