require 'rails_helper'

describe 'Usuário vê detalhes de dispositivo' do
  it 'e deve estar autenticado' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple',
                                  purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    visit equipment_path(equipment.id)

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'a partir da tela inicial' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple',
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
    equipment = Equipment.create!(client: user, name: 'Samsung J7', brand: 'Samsung',
                                  purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit equipment_index_path
    click_on 'Samsung J7'

    expect(page).to have_content 'SAMSUNG J7'
    expect(page).to have_content 'Marca:'
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'Data da compra:'
    expect(page).to have_content '01/11/2022'
    expect(page).to have_content 'Nota Fiscal'
    expect(equipment.invoice).to be_attached
    expect(equipment.photos).to be_attached
  end
end
