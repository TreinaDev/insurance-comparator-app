require 'rails_helper'

describe 'Visitante realiza uma busca por pacotes de seguros' do
  it 'a partir das categorias de produto, via menu' do
    # insurances = []
    # insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
    #                             insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 5,
    #                             product_category: 'Telefone', product_model: 'iPhone 11')
    # insurances << Insurance.new(id: 2, name: 'Premium', max_period: 24, min_period: 6, insurance_company_id: 2,
    #                             insurance_name: 'Seguradora 2', price: 400.00, product_category_id: 4,
    #                             product_category: 'Computador', product_model: 'Macbook Pro')

    # allow(Insurance).to receive(:all).and_return(insurances)
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('https://6376b6f9b5f0e1eb8511f710.mockapi.io/api/v1/insurances/product_categories').and_return(fake_response)
    # exibir as categorias disponíveis automaticamente (show das categorias recebidas via api)

    visit root_path

    expect(page).to have_content 'Telefone'
    expect(page).to have_content 'Computador'
  end

  it 'a partir de uma categoria específica do menu' do
    insurances = []
    insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 5,
                                product_category: 'Telefone', product_model: 'iPhone 11')
    insurances << Insurance.new(id: 2, name: 'Super Econômico', max_period: 24, min_period: 6, insurance_company_id: 2,
                                insurance_name: 'Seguradora 1', price: 90.00, product_category_id: 5,
                                product_category: 'Telefone', product_model: 'Xiaomi Mi 10')

    allow(Insurance).to receive(:find).with('5').and_return(insurances)
    # receber o id da categoria

    visit root_path
    click_on 'Telefone'

    expect(page).to have_content 'Categoria: Telefone'
    expect(page).to have_content 'iPhone 11'
    expect(page).to have_content 'Xiaomi Mi 10'
  end

  it 'e não há produtos disponíveis na categoria' do
    insurances = nil
    allow(Insurance).to receive(:find).with('5').and_return(insurances)

    visit root_path
    click_on 'Telefone'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar as informações desta categoria'
  end

  it 'e busca por categorias não está disponível' do
    fake_response = double("faraday_response", status: 200, body: '[]')
    allow(Faraday).to receive(:get).with('https://6376b6f9b5f0e1eb8511f710.mockapi.io/api/v1/insurances/product_categories').and_return(fake_response)

    visit root_path

    expect(page).to have_content 'Não foi possível carregar as categorias.'
  end
end