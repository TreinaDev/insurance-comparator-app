require 'rails_helper'

describe 'Cliente vê o seu perfil' do
  it 'se estiver autenticado' do
    visit profile_path

    expect(current_path).to eq new_client_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'a partir do menu' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')

    login_as client
    visit root_path
    within 'nav' do
      click_link 'Ana Lima | ana@gmail.com'
      click_link 'Meu Perfil'
    end

    expect(page).to have_content 'Nome completo: Ana Lima'
    expect(page).to have_content 'E-mail: ana@gmail.com'
    expect(page).to have_content 'CPF: 212.345.678-90'
    expect(page).to have_content 'Endereço: Rua Dr Nogueira Martins, 680 | São Paulo - SP'
    expect(page).to have_content 'Data de nascimento: 29/10/1997'
  end
end
