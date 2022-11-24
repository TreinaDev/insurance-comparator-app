require 'rails_helper'

describe 'Visitante realiza uma busca por pacotes de seguros' do
  it 'a partir das categorias de produto, via menu' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)

    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response)

    visit root_path

    expect(page).to have_content 'Telefone'
    expect(page).to have_content 'Computador'
  end

  it 'a partir de uma categoria específica do menu' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response)

    product_by_category = []
    product_by_category << Product.new(id: 5, product_model: 'iPhone 12', brand: 'Apple', product_category_id: 1,
                                       image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/produto5.jpg')
    product_by_category << Product.new(id: 6, product_model: 'Xiaomi Mi 10', brand: 'Xiaomi', product_category_id: 1,
                                       image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/produto6.jpg')
    allow(Product).to receive(:product_by_category).with('1').and_return(product_by_category)

    visit root_path
    click_on 'Telefone'

    expect(page).to have_content 'Selecione o seu Aparelho'
    expect(page).to have_content 'iPhone 12'
    expect(page).to have_content 'Xiaomi Mi 10'
  end

  it 'e não há produtos disponíveis na categoria (erro)' do
    json_data = Rails.root.join('spec/support/json/product_categories.json').read
    fake_response = double('faraday_response', status: 500, body: json_data)
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response)

    product_by_category = nil
    allow(Product).to receive(:product_by_category).with('1').and_return(product_by_category)

    visit root_path
    click_on 'Telefone'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar as informações desta categoria'
  end

  it 'e não há categorias disponíveis' do
    fake_response = double('faraday_response', status: 200, body: '{}')
    allow(Faraday).to receive(:get).with("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
                                   .and_return(fake_response)

    visit root_path

    expect(page).to have_content 'Não foi possível carregar as categorias.'
  end
end
