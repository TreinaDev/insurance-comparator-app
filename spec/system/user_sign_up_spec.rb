require 'rails_helper'

describe 'Usuário cria uma conta' do
  it 'com sucesso' do
    visit new_client_session_path
    click_link 'Criar uma conta'
    fill_in 'Nome', with: 'Thalis'
    fill_in 'CPF', with: '87956683816'
    fill_in 'Endereço', with: 'Rua Brasil, 67'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'Data de nascimento', with: '07/10/1996', type: :date 
    fill_in 'E-mail', with: 'thalis@gmail.com'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirme sua senha', with: '12345678'
    # click_button 'Criar conta'

    # expect(page).to have_content 'Cadastro realizado com sucesso'
    # expect(page).to have_content 'Olá Thalis'
    # expect(page).to have_content 'thalis@gmail.com'
    # expect(page).to have_link 'Sair'
    # expect(page).not_to have_link 'Entrar'
    # expect(page).not_to have_content 'Não foi possível criar usuário.'
  end
end




  