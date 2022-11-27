require 'rails_helper'

describe 'Usuário cadastra dispositivo' do
  it 'a partir da tela inicial' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'

    expect(page).to have_content 'Cadastro de Dispositivo'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Valor'
    expect(page).to have_field 'Marca'
    expect(page).to have_field 'Data da compra'
    expect(page).to have_field 'Nota Fiscal'
    expect(page).to have_field 'Fotos'
  end

  it 'com sucesso' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'IPHONE 14 - PROMAX'
    select 'Telefone', from: 'Categoria'
    fill_in 'Valor', with: '10199'
    fill_in 'Marca', with: 'Apple'
    fill_in 'Data da compra', with: '01/11/2022'
    attach_file 'Nota Fiscal', Rails.root.join('spec/support/invoice.png')
    attach_file 'Fotos', [Rails.root.join('spec/support/photo_1.png'), Rails.root.join('spec/support/photo_2.jpg')]
    click_on 'Salvar'

    expect(page).to have_content 'Seu dispositivo foi cadastrado com sucesso!'
    expect(page).to have_content 'IPHONE 14 - PROMAX'
    expect(page).to have_content 'Categoria: Telefone'
    expect(page).to have_content 'Valor: R$ 10.199,00'
    expect(page).to have_content 'Marca: Apple'
    expect(page).to have_content 'Data da compra: 01/11/2022'
    expect(page).to have_css('img[src*="invoice.png"]')
    expect(page).to have_css('img[src*="photo_1.png"]')
    expect(page).to have_css('img[src*="photo_2.jpg"]')
  end

  it 'e não é possível cadastrar o dispositivo' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: nil
    fill_in 'Marca', with: nil
    fill_in 'Data da compra', with: nil
    attach_file 'Nota Fiscal', nil
    attach_file 'Fotos', nil
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível registrar o seu dispositivo.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
    expect(page).to have_content 'Marca não pode ficar em branco'
    expect(page).to have_content 'Data da compra não pode ficar em branco'
    expect(page).to have_content 'Nota Fiscal não pode ficar em branco'
    expect(page).to have_content 'Fotos não pode ficar em branco'
  end

  it 'com valor menor ou igual a 0' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit new_equipment_path
    fill_in 'Valor', with: '-200'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível registrar o seu dispositivo.'
    expect(page).to have_content 'Valor deve ser maior que 0'
  end

  it 'e volta para tela inicial' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Comparador de seguros'

    expect(current_path).to eq root_path
  end

  it 'e volta para tela dos dispositivos' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                          state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

    login_as(user)
    visit(root_path)
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Cadastrar Novo'
    click_on 'Meus Dispositivos'

    expect(current_path).to eq equipment_index_path
  end
end
