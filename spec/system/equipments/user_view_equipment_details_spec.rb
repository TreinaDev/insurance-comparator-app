require 'rails_helper'

describe 'Usuário vê detalhes de dispositivo' do
  it 'e deve estar autenticado' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', equipment_price: 10_199,
                                  purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    visit equipment_path(equipment.id)

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'a partir da tela inicial' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', equipment_price: 10_199,
                                  purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Iphone 14 - ProMax'

    expect(page).to have_content 'IPHONE 14 - PROMAX'
    expect(page).to have_content 'Marca:'
    expect(page).to have_content 'Data da compra:'
    expect(page).to have_content '01/11/2022'
    expect(page).to have_content 'Nota Fiscal'
    expect(equipment.invoice).to be_attached
    expect(equipment.photos).to be_attached
  end

  it 'a partir da tela de dispositivos' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Samsung J7', brand: 'Samsung', equipment_price: 10_199,
                                  purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit equipment_index_path
    click_on 'Samsung J7'

    expect(page).to have_content 'SAMSUNG J7'
    expect(page).to have_content 'Valor: R$ 10.199,00'
    expect(page).to have_content 'Marca:'
    expect(page).to have_content 'SAMSUNG'
    expect(page).to have_content 'Data da compra:'
    expect(page).to have_content '01/11/2022'
    expect(page).to have_content 'Nota Fiscal'
    expect(equipment.invoice).to be_attached
    expect(equipment.photos).to be_attached
  end
end
