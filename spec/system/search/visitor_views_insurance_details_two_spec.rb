require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    json_data = Rails.root.join('spec/support/json/insurances.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurances/#{@query}").and_return(fake_response)

    json_data_one = Rails.root.join('spec/support/json/insurance.json').read
    fake_response_one = double('faraday_response', success?: true, body: json_data_one)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@id}").and_return(fake_response_one)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
  end

  it 'e não consegue visualizar o pacote' do
    json_data = Rails.root.join('spec/support/json/insurances.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurances/#{@query}").and_return(fake_response)

    fake_response_one = double('faraday_response', success?: false, body: '{}')
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@id}").and_return(fake_response_one)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'

    expect(current_path).to eq search_path
    expect(page).to have_content 'Não foi possível carregar as informações do pacote'
  end
end
