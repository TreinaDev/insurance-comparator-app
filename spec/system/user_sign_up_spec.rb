require 'rails_helper'

describe 'Usuário cria uma conta' do
  it 'com sucesso' do
    visit root_path
    click_link 'Entrar'
    click_link 'Criar uma conta'
    fill_in 'Nome completo', with: 'Thalis'
    fill_in 'CPF', with: '87956683816'
    fill_in 'Endereço', with: 'Rua Brasil, 67'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'Data de nascimento', with: '07/10/1996'
    fill_in 'E-mail', with: 'thalis@gmail.com'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirme sua senha', with: '12345678'
    click_button 'Criar conta'

    expect(page).to have_content 'Cadastro realizado com sucesso.'
    expect(page).to have_content 'Thalis | thalis@gmail.com'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
  end

  it 'e deixa campos obrigatórios em branco' do
    visit new_client_registration_path
    fill_in 'Nome completo', with: ''
    fill_in 'CPF', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_button 'Criar conta'

    expect(page).to have_content 'Não foi possível realizar o cadastro. Por favor, verifique os erros abaixo:'
    expect(page).to have_content 'Nome completo não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Data de nascimento não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).not_to have_content 'Cadastro realizado com sucesso.'
    expect(current_path).not_to eq root_path
  end

  it 'com dados inválidos' do
    visit root_path

    click_link 'Entrar'
    click_link 'Criar uma conta'
    fill_in 'CPF', with: '879566838112'
    fill_in 'Estado', with: 'S'
    fill_in 'E-mail', with: 'thalis.'
    fill_in 'Senha', with: '123'
    fill_in 'Confirme sua senha', with: '123'
    click_button 'Criar conta'

    expect(page).to have_content 'Estado não possui o tamanho esperado (2 caracteres)'
    expect(page).to have_content 'CPF não possui o tamanho esperado (11 caracteres)'
    expect(page).to have_content 'Senha é muito curto (mínimo: 6 caracteres)'
    expect(page).to have_content 'E-mail deve estar no formato email@email.com'
    expect(page).not_to have_button 'Sair'
    expect(page).to have_link 'Entrar'
  end
end




  