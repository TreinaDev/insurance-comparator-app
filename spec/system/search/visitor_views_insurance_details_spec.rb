require 'rails_helper'

describe 'Visitante procura seguros para o seu produto' do
  it 'e encontra pacotes com sucesso' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)
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

    expect(page).to have_content 'Nome da Seguradora: Anjo Seguradora'
    expect(page).to have_content 'Tipo de Pacote: Super Premium'
    expect(page).to have_content 'Período Mínimo de Contratação: 12 meses'
    expect(page).to have_content 'Período Máximo de Contratação: 24 meses'
    expect(page).to have_content 'Contratação por 12 meses: R$ 900,00'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Nome da Seguradora: Anjo Seguradora'
    expect(page).to have_content 'Período Mínimo de Contratação: 6 meses'
    expect(page).to have_content 'Período Máximo de Contratação: 24 meses'
    expect(page).to have_content 'Contratação por 12 meses: R$ 840,00'
  end

  it 'e vê detalhes de um pacote' do
    json_data1 = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data1)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    json_data_filt_product = Rails.root.join('spec/support/json/filtered_products.json').read
    fake_response_filt_product = double('faraday_response', status: 200, body: json_data_filt_product)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']
                                          }/products/query?id=iphone")
                                   .and_return(fake_response_filt_product)

    json_data_product = Rails.root.join('spec/support/json/product_iphone.json').read
    fake_response_product = double('faraday_response', status: 200, body: json_data_product)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1")
                                   .and_return(fake_response_product)

    json_data2 = Rails.root.join('spec/support/json/insurances.json').read
    fake_response2 = double('faraday_response', status: 200, body: json_data2)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1/packages")
                                   .and_return(fake_response2)

    json_data3 = Rails.root.join('spec/support/json/insurance.json').read
    fake_response3 = double('faraday_response', status: 200, body: json_data3)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/1/packages/4")
                                   .and_return(fake_response3)

    visit root_path
    fill_in 'Produto', with: 'iphone'
    click_on 'Buscar'
    click_on 'iPhone 12'
    click_on 'Super Econômico'

    expect(page).to have_content 'Nome da Seguradora: Anjo Seguradora'
    expect(page).to have_content 'Tipo de Pacote: Super Econômico'
    expect(page).to have_content 'Produto: iPhone 12'
    expect(page).to have_content 'Valor da Contratação: R$ 1.200,00' # incluir mais expects
  end

  it 'e não há pacotes para o produto' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response1 = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response1)

    products = []
    products << Product.new(id: 5, product_model: 'iPhone 11', brand: 'Apple', product_category_id: 1,
                            image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')
    allow(Product).to receive(:search).with('iPhone 11').and_return(products)

    fake_response1 = double('faraday_response', status: 200, body: '[]')
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/products/5/packages")
                                   .and_return(fake_response1)
    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'iPhone 11'

    expect(page).to have_content 'Não há pacotes disponíveis para este produto.'
  end
end
