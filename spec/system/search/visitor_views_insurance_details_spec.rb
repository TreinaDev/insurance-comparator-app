require 'rails_helper'

describe 'Visitante procura seguros para o seu produto' do
  it 'e encontra pacotes com sucesso' do
    products = []
    products << Product.new(id: 1, product_model: 'Samsung Galaxy S20', brand: 'Samsung', product_category_id: 1,
                            image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')
    allow(Product).to receive(:search).with('Samsung Galaxy S20').and_return(products)

    json_data = Rails.root.join('spec/support/json/insurances.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1/packages")
                                   .and_return(fake_response)

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
    json_data1 = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data1)
    allow(Faraday).to receive(:get).with(
      "#{Rails.configuration.external_apis['insurance_api']}/product_categories"
    ).and_return(fake_response1)

    json_data2 = Rails.root.join('spec/support/json/filtered_products.json').read
    fake_response2 = double('faraday_response', status: 200, body: json_data2)
    allow(Faraday).to receive(:get).with(
      "#{Rails.configuration.external_apis['insurance_api']}/products/query?id=iphone").and_return(fake_response2)

    json_data3 = Rails.root.join('spec/support/json/insurances.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/4/packages")
                                   .and_return(fake_response3)

    visit root_path
    fill_in 'Produto', with: 'iphone'
    click_on 'Buscar'
    click_on 'iPhone 12'
    click_on 'Super Econômico'

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Produto: iPhone 12'
    expect(page).to have_content 'Valor da Contratação: R$ 100,00'
  end

  it 'e não há pacotes para o produto' do
    products = []
    products << Product.new(id: 5, product_model: 'iPhone 11', brand: 'Apple', product_category_id: 1,
                            image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')
    allow(Product).to receive(:search).with('iPhone 11').and_return(products)

    insurance = nil
    allow(Insurance).to receive(:find).with(1).and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'iPhone 11'

    expect(page).to have_content 'Não há pacotes disponíveis para este produto.'
  end
end
