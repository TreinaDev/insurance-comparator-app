require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    insurances = []
    insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                                product_model: 'iPhone 11')
    insurances << Insurance.new(id: 4, name: 'Super Premium', max_period: 12, min_period: 2, insurance_company_id: 2,
                                insurance_name: 'Seguradora 2', price: 500.00, product_category_id: 1, product_category: 'Telefone',
                                product_model: 'iPhone 11')
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(insurances)

    insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                                product_model: 'iPhone 11')
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Super Econômico'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Produto: iPhone 11'
    expect(page).to have_content 'Valor da Contratação: R$ 100,00'
    expect(page).not_to have_content 'Nome da Seguradora: Seguradora 2'
    expect(page).not_to have_content 'Tipo de Pacote: Plus'
    expect(page).not_to have_content 'Valor da Contratação: R$ 20,00'
  end

  it 'e não consegue visualizar o pacote' do
    insurances = []
    insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1, product_category: 'Telefone',
                                product_model: 'iPhone 11')
    insurances << Insurance.new(id: 4, name: 'Super Premium', max_period: 12, min_period: 2, insurance_company_id: 2,
                                insurance_name: 'Seguradora 2', price: 500.00, product_category_id: 1, product_category: 'Telefone',
                                product_model: 'iPhone 11')
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(insurances)

    insurance = nil
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Super Econômico'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar as informações do pacote'
  end
end
