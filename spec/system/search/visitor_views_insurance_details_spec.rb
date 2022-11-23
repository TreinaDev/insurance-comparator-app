require 'rails_helper'

describe 'Visitante vê seguros para o seu produto' do
  it 'com sucesso' do
    json_data_product = File.read(Rails.root.join('spec/support/json/product.json'))
    fake_response_product = double('faraday_response', status: 200, body: json_data_product)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/products/1').and_return(fake_response_product)

    json_data_insurances = File.read(Rails.root.join('spec/support/json/insurances.json'))
    fake_response_insurances = double('faraday_response', status: 200, body: json_data_insurances)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/products/1/packages').and_return(fake_response_insurances)

    visit root_path
    fill_in 'Produto', with: 'Samsung Galaxy S20'
    click_on 'Buscar'
    click_on 'Samsung Galaxy S20'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Super Premium'
    expect(page).to have_content 'Produto: Samsung Galaxy S20'
    expect(page).to have_content 'Período Mínimo de Contratação: 12 meses'
    expect(page).to have_content 'Período Máximo de Contratação: 24 meses'
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ 900,00'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 2'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Produto: Samsung Galaxy S20'
    expect(page).to have_content 'Período Mínimo de Contratação: 6 meses'
    expect(page).to have_content 'Período Máximo de Contratação: 24 meses'
    expect(page).to have_content 'Valor da Contratação por 12 meses: R$ 624,00'
  end

  it 'e vê detalhes de um pacote' do
    insurances = []
    insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'Samsung Galaxy S20',
                                product_model_id: 1, coverages: 'Furto', services: '12')

    insurances << Insurance.new(id: 4, name: 'Super Premium', max_period: 12, min_period: 2, insurance_company_id: 2,
                                insurance_name: 'Seguradora 2', price: 500.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'Samsung Galaxy S20', product_model_id: 1, 
                                coverages: ['Furto', 'Molhar'], services: '123')
    allow(Insurance).to receive(:find).with('1').and_return(insurances)

    insurance = Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'Samsung Galaxy S20', 
                                product_model_id: 1, coverages:'Furto', services:'12')

    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Samsung Galaxy S20'
    click_on 'Super Econômico'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Produto: iPhone 11'
    expect(page).to have_content 'Valor da Contratação: R$ 100,00'
  end

  it 'e não consegue visualizar o pacote' do
    insurances = []
    insurances << Insurance.new(id: 1, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 1', price: 100.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'Samsung Galaxy S20', 
                                product_model_id: 1, coverages:'Furto', services:'12')
                                
    insurances << Insurance.new(id: 4, name: 'Super Premium', max_period: 12, min_period: 2, insurance_company_id: 2,
                                insurance_name: 'Seguradora 2', price: 500.00, product_category_id: 1,
                                product_category: 'Telefone', product_model: 'Samsung Galaxy S20', product_model_id: 1, 
                                coverages: ['Furto', 'Molhar'], services: '123')
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
