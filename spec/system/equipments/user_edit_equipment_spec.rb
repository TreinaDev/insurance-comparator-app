require 'rails_helper'

describe 'Usuário edita um dispositivo' do
  it 'com sucesso' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Iphone 14 - ProMax'
    click_on 'Editar'
    fill_in 'Nome', with: 'Iphone 13 - ProMax'
    fill_in 'Data da compra', with: '01/10/2017'
    attach_file 'Nota Fiscal', Rails.root.join('spec/support/invoice.png')
    attach_file 'Fotos', [Rails.root.join('spec/support/photo_1.png'), Rails.root.join('spec/support/photo_2.jpg')]
    click_on 'Salvar'

    expect(page).to have_content 'Seu dispositivo foi atualizado com sucesso!'
    expect(page).not_to have_content 'IPHONE 14 - PROMAX'
    expect(page).to have_content 'IPHONE 13 - PROMAX'
    expect(page).to have_content 'Marca: Apple'
    expect(page).not_to have_content 'Data da compra: 01/11/2022'
    expect(page).to have_content 'Data da compra: 01/10/2017'
    expect(page).to have_css('img[src*="invoice.png"]')
    expect(page).to have_css('img[src*="photo_1.png"]')
    expect(page).to have_css('img[src*="photo_2.jpg"]')
  end

  it 'e não é possível atualizar o dispositivo' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                      invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                      photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Iphone 14 - ProMax'
    click_on 'Editar'
    fill_in 'Nome', with: nil
    fill_in 'Marca', with: nil
    fill_in 'Data da compra', with: nil
    attach_file 'Fotos', nil
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível editar o seu dispositivo.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Marca não pode ficar em branco'
    expect(page).to have_content 'Data da compra não pode ficar em branco'
    expect(page).to have_content 'Fotos não pode ficar em branco'
  end

  it 'e volta para tela inicial' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Iphone 14 - ProMax'
    click_on 'Editar'
    click_on 'Voltar'

    expect(current_path).to eq equipment_path(equipment.id)
  end

  it 'se o dispositivo não estiver vinculado a um pedido' do 
    client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client: client, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                          fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    order = Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                          client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                          product_model: insurance.product_category, price: insurance.price,
                          insurance_company_id: insurance.insurance_company_id)

    login_as client
    visit edit_equipment_path(equipment)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não é possível editar um equipamento que está vinculado a um pedido.'
  end
end
