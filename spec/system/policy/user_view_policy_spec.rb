require 'rails_helper'

describe 'Usuário vê apólice' do 
  it 'a partir da tela inicial' do
    json_data = File.read(Rails.root.join('spec/support/json/policy.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/equipment/1/policy').and_return(fake_response)
    
    visit root_path
    click_on 'Usuário 1 | usuario@email.com'
    click_on 'Meus Dispositivos'
    click_on 'Samsung J7'
    click_on 'Ver apólice'

    expect(page).to have_content 'Código da apólice:'
    expect(page).to have_content 'ALOPJ452NB'
    expect(page).to have_content 'Marca:'
    expect(page).to have_content 'Samsung J7'
    expect(page).to have_content 'Modelo do produto:'
    expect(page).to have_content 'Samsung Android'
    expect(page).to have_content 'Data da compra:'
    expect(page).to have_content '01/11/2022'
    expect(page).to have_content 'Seguradora:'
    expect(page).to have_content 'Seguradora 2'
    expect(page).to have_content 'Pacote:'
    expect(page).to have_content 'Plus'
    expect(page).to have_content 'Período de vigência:'
    expect(page).to have_content '10/10/2024'
    expect(page).to have_content 'Cliente:'
    expect(page).to have_content 'Mario Silva:'
    expect(page).to have_content 'Data de nascimento:'
    expect(page).to have_content '29/05/1985'
    expect(page).to have_content 'CPF:'
    expect(page).to have_content '879.566.838-17'
    expect(page).to have_content 'E-mail:'
    expect(page).to have_content 'mario@sistemadeseguros.com'
    expect(page).to have_content 'Endereço:'
    expect(page).to have_content 'Rua Dr Nogueira Martins, 555',
    expect(page).to have_content 'Cidade:',
    expect(page).to have_content 'São Paulo',
    expect(page).to have_content 'Estado:',
    expect(page).to have_content 'SP',
  end
end