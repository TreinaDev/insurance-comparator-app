require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    dados_fake = []
    dados_fake << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    dados_fake_one = []
    dados_fake_one << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    allow(Insurance).to receive(:find).with('1').and_return(dados_fake_one)

    visit root_path
    fill_in 'Produto',	with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'
    
    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
  end
  it 'e não consegue visualizar o pacote' do
    dados_fake = []
    dados_fake << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    json_data = Rails.root.join('spec/support/json/insurance.json').read
    fake_response = double('faraday_response', success?: true, body: "{}")
    
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurance/1').and_return(fake_response)
 
    visit root_path
    fill_in 'Produto',	with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'
    
    expect(page).to have_content 'Não foi possível carregar as informações do pacote'
  end
end