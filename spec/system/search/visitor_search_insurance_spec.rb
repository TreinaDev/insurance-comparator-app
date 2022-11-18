require 'rails_helper'

describe 'Visitante realiza uma busca por seguradoras' do
  it 'a partir da página inicial' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas ao Comparador de Seguros'
    expect(page).to have_content 'Informe abaixo o nome do seu produto para encontrar os Pacotes de Seguro compatíveis'
    expect(page).to have_field 'Produto'
    expect(page).to have_button 'Buscar'
  end

  it 'a partir do nome do seu produto' do
    dados_fake = []
    dados_fake << Insurance.new(id: 2, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, 
                                product_category: 'Telefone', product_model: 'iPhone 11')

    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'

    expect(current_path).to eq search_path
    expect(page).to have_content 'Resultado da Busca: iPhone 11'
    expect(page).to have_content 'Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Valor da Contratação: R$ 100,00'
  end

  it 'e não encontra seguradoras para o seu produto' do
    dados_fake = []
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhuma Seguradora encontrada'
  end
end
