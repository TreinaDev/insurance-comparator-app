require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    insurances = []
    insurances << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    insurances << Insurance.new(id: 2, insurance_name: 'Seguradora 2', product_model: 'iPhone 11', packages: 'Plus',
                                price: 20)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(insurances)

    insurance = Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                              price: 50)
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
    expect(page).not_to have_content 'Nome da Seguradora: Seguradora 2'
    expect(page).not_to have_content 'Tipo de Pacote: Plus'
    expect(page).not_to have_content 'Valor de Contratação para 12 meses: R$ 20,00'
  end

  it 'e não consegue visualizar o pacote' do
    insurances = []
    insurances << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    insurances << Insurance.new(id: 2, insurance_name: 'Seguradora 2', product_model: 'iPhone 11', packages: 'Plus',
                                price: 20)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(insurances)

    insurance = nil
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar as informações do pacote'
  end
end
