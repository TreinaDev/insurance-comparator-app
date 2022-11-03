require 'rails_helper'

describe 'Usuário vê campos' do
  it 'a partir da tela inicial' do
    visit new_client_session_path
   
    expect(page).to have_text 'Entrar'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field('Lembre-se de mim', checked: false)
    expect(page).to have_button 'Entrar'
    expect(page).to have_link 'Esqueceu sua senha?'
    expect(page).not_to have_field 'CPF'
    expect(page).not_to have_field 'Nome'
    expect(page).not_to have_button 'Criar conta'
  end

  it 'e se autentica com sucesso' do
    Client.create!(name: 'Thalis', email: 'thalis@gmail.com', password: '12345678')

    visit new_client_session_path
    fill_in 'E-mail', with: 'thalis@gmail.com'
    fill_in 'Senha', with: '12345678'
    # click_button 'Entrar'

    # expect(page).to have_content 'Olá Thalis'
    # expect(page).to have_content 'thalis@gmail.com'
    # expect(page).to have_link 'Sair'
    # expect(page).to have_text 'Entrar'
    # expect(page).not_to have_link 'Entrar'
    # expect(page).not_to have_link 'Criar uma conta'
    # expect(page).not_to have_link 'Esqueceu sua senha?'
    # expect(page).not_to have_content 'Não foi possível criar usuário.'
  end
end




  
  