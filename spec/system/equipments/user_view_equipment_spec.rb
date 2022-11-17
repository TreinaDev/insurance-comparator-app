require 'rails_helper'

describe 'Usuário vê dispositivos' do
  it 'e deve estar autenticado' do
    visit equipment_index_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
    expect(current_path).to eq new_client_session_path
  end

  it 'a partir da tela inicial' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'

    expect(page).to have_content 'Iphone 14 - ProMax'
    expect(page).to have_content 'Marca: Apple'
    expect(page).to have_content 'Data da compra: 01/11/2022'
  end

  it 'e vê somente os seus dispositivos' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    second_user = Client.create!(name: 'Usuário 2', cpf: '60536252051', address: 'Rua Primavera, 424',
                                 city: 'Bauru', state: 'SP', birth_date: '12/05/1998', email: 'usuario2@email.com',
                                 password: 'password')
    Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'),
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(second_user)
    visit root_path
    click_on 'Usuário 2 | usuario2@email.com'
    click_on 'Meus Dispositivos'

    expect(page).not_to have_content 'Iphone 14 - ProMax'
    expect(page).not_to have_content 'Apple'
    expect(page).not_to have_content '01/11/2022'
  end

  it 'e não há dispositivos cadastrados' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'

    expect(page).to have_content 'Nenhum dispositivo encontrado'
  end
end
