require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    dados_fake = Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                               price: 50)
    allow(Insurance).to receive(:find).with('1').and_return(dados_fake)

    json_data = Rails.root.join('spec/support/json/insurance.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurance/1').and_return(fake_response)

    visit insurance_path(dados_fake.id)

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ 50,00'
  end
end
