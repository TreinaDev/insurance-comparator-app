require 'rails_helper'

describe 'Usuário faz autenticação' do
  it 'a partir da tela inicial' do
    Client.create!(name: 'Thalis', email: 'thalis@gmail.com', password: '12345678', cpf: '02938477569',
                   address: 'Rua das Rosas, 350', city: 'Salvador', state: 'BA', birth_date: '09-02-1998')

    visit root_path
    click_link 'Entrar'
    fill_in 'E-mail', with: 'thalis@gmail.com'
    fill_in 'Senha', with: '12345678'
    click_button 'Entrar'

    expect(page).to have_content 'Thalis | thalis@gmail.com'
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_button 'Entrar'
    expect(page).not_to have_link 'Criar uma conta'
    expect(page).not_to have_link 'Esqueceu sua senha?'
    expect(page).not_to have_content 'Não foi possível criar usuário.'
  end

  it 'com dados inválidos' do
    Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                   address:'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP', 
                   birth_date: '29/10/1997')

    visit new_client_session_path
    fill_in 'E-mail', with: 'ana'
    fill_in 'Senha', with: '1234'
    click_button 'Entrar'

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
  end
end




  
  