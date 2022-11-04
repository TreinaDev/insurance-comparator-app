require 'rails_helper'

describe 'Visitante realiza uma busca por seguradoras' do
  it 'a partir da página inicial' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas Vindas Ao Comparador de Seguros'
    expect(page).to have_field 'Produto'
    expect(page).to have_button 'Buscar'
  end

  it 'a partir do nome do seu produto' do
    json_data = File.read(Rails.root.join('spec/support/json/insurances.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@query}").and_return(fake_response)

    visit root_path
    fill_in 'Produto',	with: 'Iphone 11'
    click_on 'Buscar'

    expect(current_path).to eq search_path
    expect(page).to have_content 'Resultado da Busca: Iphone 11'
    expect(page).to have_content 'Seguradora: '
    expect(page).to have_content 'Tipo de Pacote: '
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ '
  end

  it 'e não encontra seguradoras para o seu produto' do
    fake_response = double('faraday_response', status: 200, body: '[]')
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@query}").and_return(fake_response)

    visit root_path
    fill_in 'Produto',	with: 'Iphone 11'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhuma Seguradora encontrada'
  end
end
