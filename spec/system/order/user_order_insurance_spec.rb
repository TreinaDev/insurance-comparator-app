require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'se estiver autenticado' do
    insurance = Insurance.new(id: 76, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                              price: 50)
    allow(Insurance).to receive(:find).with('76').and_return(insurance)

    visit insurance_path(insurance.id)
    click_link 'Contratar'

    expect(current_path).to eq new_client_session_path
  end

  it 'se tiver um dispositivo cadastrado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    insurance = Insurance.new(id: 44, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                              price: 50)
    allow(Insurance).to receive(:find).with('44').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'

    expect(current_path).to eq new_equipment_path
    expect(page).to have_content 'É necessário cadastrar um dispositivo para contratar o seguro'
  end

  it 'a partir da página de detalhes do pacote' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple',
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    Equipment.create!(client:, name: 'Samsung SX', brand: 'Samsung',
                      purchase_date: '28/09/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, insurance_name: 'Seguradora 67', product_model: 'iPhone 11', packages: 'Premium',
                              price: 50)

    allow(Insurance).to receive(:find).with('67').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'

    expect(current_path).to eq new_insurance_order_path(insurance.id)
    expect(page).to have_content 'Aquisição do Seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 67'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ 50,00'
    expect(page).to have_select 'Dispositivo', text: 'iphone 11'
    expect(page).to have_select 'Dispositivo', text: 'Samsung SX'
    expect(page).to have_field 'Período de contratação em meses', type: :number
    expect(page).to have_select 'Meio de Pagamento'
    expect(page).to have_button 'Contratar Pacote'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                      purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 45, insurance_name: 'Seguradora 45', product_model: 'iPhone 11', packages: 'Premium',
                              price: 2.5)

    allow(Insurance).to receive(:find).with('45').and_return(insurance)

    login_as(client)
    visit insurance_path(insurance.id)
    click_link 'Contratar'
    select 'iphone 11', from: 'Dispositivo'
    fill_in 'Período de contratação em meses', with: 7
    select 'Cartão de crédito', from: 'Meio de Pagamento'
    click_button 'Contratar Pacote'

    expect(page).to have_content 'Seu pedido está em análise pela seguradora'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Período contratado: 7 meses'
    expect(page).to have_content 'Porcentagem do Seguro: 2.5%'
    expect(page).to have_content 'Valor do Seguro: R$ 175,00'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Dispositivo: iphone 11'
    expect(page).to have_content 'Status: Aguardando Aprovação da Seguradora'
  end

  # testar cenários de erro
end
