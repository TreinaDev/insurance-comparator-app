require 'rails_helper'

describe 'Cliente edita seu perfil' do
  it 'e deve estar autenticado' do
    Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                   address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                   birth_date: '29/10/1997')

    visit edit_client_registration_path

    expect(current_path).to eq new_client_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'com sucesso' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    login_as(client)
    visit edit_client_registration_path
    fill_in 'Nome', with: 'Ricardo Silva'
    fill_in 'E-mail', with: 'ricardosilva@gmail.com'
    fill_in 'Data de nascimento', with: '07/10/1995'
    fill_in 'CPF', with: '87956683816'
    fill_in 'Senha atual', with: '12345678'
    fill_in 'Senha', with: '234567'
    fill_in 'Confirme sua senha', with: '234567'
    fill_in 'Endereço', with: 'Endereço: Rua Dr Nogueira Martins, 680 | Salvador - BA'
    click_on 'Salvar'
    click_on 'Ricardo Silva | ricardosilva@gmail.com'

    expect(page).to have_content('E-mail: ricardosilva@gmail.com')
    expect(page).to have_content('Data de nascimento: 07/10/1995')
    expect(page).to have_content('CPF: 87956683816')
    expect(page).to have_content('Endereço: Rua Dr Nogueira Martins, 680 | Salvador - BA')
  end

  it 'a partir da tela do seu perfil' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    login_as(client)
    visit client_path(client)
    click_link 'Editar perfil'
    fill_in 'Nome', with: 'Maria Souza'
    fill_in 'CPF', with: '87956683816'
    fill_in 'E-mail', with: 'mariasouza@hotmail.com'
    fill_in  'Senha atual', with: '12345678'
    fill_in  'Senha', with: '234567'
    fill_in  'Confirme sua senha', with: '234567'
    fill_in  'Data de nascimento', with: '07/10/1953'
    fill_in  'Endereço', with: 'Endereço: Rua das Laranjeiras, 543 | Rio Branco - AC'
    click_on 'Salvar'

    expect(page).to have_link 'Maria Souza | mariasouza@hotmail.com', href: client_path(client)
    expect(page).to have_content 'A sua conta foi atualizada com sucesso.'
  end

  it 'e deixa campos obrigatórios em branco' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    login_as(client)
    visit edit_client_registration_path
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in  'Data de nascimento', with: ''
    fill_in  'CPF', with: ''
    fill_in  'Endereço', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Nome completo não pode ficar em branco')
    expect(page).to have_content('Endereço não pode ficar em branco')
    expect(page).to have_content('E-mail não pode ficar em branco')
    expect(page).to have_content('Data de nascimento não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('Senha atual não pode ficar em branco')
  end

  it 'com dados inválidos' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    login_as(client)
    visit edit_client_registration_path
    fill_in 'Nome', with: 123
    fill_in 'E-mail', with: 890
    fill_in  'Endereço', with: 1
    fill_in  'Cidade', with: 2
    fill_in  'Estado', with: 3
    fill_in  'CPF', with: '1234'
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível realizar o cadastro. Por favor, verifique os erros abaixo:')
    expect(page).to have_content('Nome completo não é válido')
    expect(page).to have_content('E-mail não é válido')
    expect(page).to have_content('Endereço não é válido')
    expect(page).to have_content('Cidade não é válido')
    expect(page).to have_content('Estado não é válido')
    expect(page).to have_content('CPF não possui o tamanho esperado (11 caracteres)')
  end
end
