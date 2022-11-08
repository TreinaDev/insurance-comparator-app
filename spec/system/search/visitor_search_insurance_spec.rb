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
    dados_fake = []
    dados_fake << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    visit root_path
    fill_in 'Produto',	with: 'iPhone 11'
    click_on 'Buscar'

    expect(current_path).to eq search_path
    expect(page).to have_content 'Resultado da Busca: iPhone 11'
    expect(page).to have_content 'Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ 50,00'
  end

  it 'e não encontra seguradoras para o seu produto' do
    dados_fake = []
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    visit root_path
    fill_in 'Produto',	with: 'iPhone 11'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhuma Seguradora encontrada'
  end
end
