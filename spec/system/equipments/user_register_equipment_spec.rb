require 'rails_helper'

describe 'Usuário cadastra dispositivo' do
  it 'a partir da tela inicial' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'

    expect(page).to have_content 'Cadastro de Dispositivo'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Marca'
    expect(page).to have_field 'Data da compra'
    expect(page).to have_field 'Nota Fiscal'
    expect(page).to have_field 'Fotos'
  end

  it 'com sucesso' do
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'Iphone 14 - ProMax'
    fill_in 'Marca', with: 'Apple'
    fill_in 'Data da compra', with: '01/11/2022'
    attach_file 'Nota Fiscal', Rails.root.join('spec/support/invoice.png')
    attach_file 'Fotos', [Rails.root.join('spec/support/photo_1.png'), Rails.root.join('spec/support/photo_2.jpg')]
    click_on 'Salvar'

    expect(page).to have_content 'Seu dispositivo foi cadastrado com sucesso!'
    expect(page).to have_content 'Iphone 14 - ProMax'
    expect(page).to have_content 'Marca: Apple'
    expect(page).to have_content 'Data da compra: 01/11/2022'
    expect(page).to have_css('img[src*="invoice.png"]')
    expect(page).to have_css('img[src*="photo_1.png"]')
    expect(page).to have_css('img[src*="photo_2.jpg"]')
  end
end
