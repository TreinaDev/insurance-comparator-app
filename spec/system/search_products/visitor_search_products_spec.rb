require 'rails_helper'

describe 'Visitante realiza uma busca por produto' do
  it 'a partir da página inicial' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas ao Comparador de Seguros'
    expect(page).to have_content 'Informe abaixo o nome do seu produto para encontrar os Pacotes de Seguro compatíveis'
    expect(page).to have_field 'Produto'
    expect(page).to have_button 'Buscar'
  end

  it 'a partir do nome do seu produto' do
    products = []
    products << Product.new(id: 1, product_model: 'Samsung Galaxy S20', brand: 'Samsung', product_category_id: 1,
                            image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')

    allow(Product).to receive(:search).with('Samsung Galaxy S20').and_return(products)

    visit root_path
    fill_in 'Produto', with: 'Samsung Galaxy S20'
    click_on 'Buscar'

    expect(current_path).to eq search_path
    expect(page).to have_content 'Resultado da Busca: Samsung Galaxy S20'
    expect(page).to have_content 'Samsung Galaxy S20'
    expect(page).to have_content 'Marca: Samsung'
    expect(page).to have_css("img[src*='http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg']")
  end

  it 'e não encontra produtos correspondentes' do
    products = []
    allow(Product).to receive(:search).with('iPhone 11').and_return(products)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum produto encontrado'
  end
end
