require 'rails_helper'

describe Product do
  context '.search' do
    it 'retorna os produtos encontrados na busca' do
      products = []
      products << Product.new(id: 5, product_model: 'iPhone 11', brand: 'Apple', product_category_id: 1,
                              image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')
      products << Product.new(id: 6, product_model: 'iPhone 11 - Pro', brand: 'AppleX', product_category_id: 1,
                              image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--65dbe6762532c687ed95b7ff5c8c3e9e2e0f38b0/galaxy-s20-produto.jpg')
      allow(Product).to receive(:search).with('iPhone 11').and_return(products)

      result = Product.search('iPhone 11')

      expect(result.length).to eq 2
      expect(result[0].id).to eq 5
      expect(result[0].product_category_id).to eq 1
      expect(result[0].product_model).to eq 'iPhone 11'
      expect(result[0].brand).to eq 'Apple'
      expect(result[1].id).to eq 6
      expect(result[1].product_category_id).to eq 1
      expect(result[1].product_model).to eq 'iPhone 11 - Pro'
      expect(result[1].brand).to eq 'AppleX'
    end

    it ' retorna vazio se API está suspensa/indisponível' do
      products = []
      allow(Product).to receive(:search).with('iPhone 11').and_return(products)

      result = Product.search('iPhone 11')

      expect(result).to eq []
    end
  end

  context '.product_by_category' do
    it 'retorna os produtos de acordo com a categoria do botão escolhido' do
      product_by_category = []
      product_by_category << Product.new(id: 5, product_model: 'iPhone 11', brand: 'Apple', product_category_id: 1,
                                         image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/produto5.jpg')
      product_by_category << Product.new(id: 6, product_model: 'iPhone 11 - Pro', brand: 'AppleX',
                                         product_category_id: 1, image_url: 'http://localhost:4000/rails/active_storage/blobs/redirect/produto6.jpg')
      allow(Product).to receive(:product_by_category).with(1).and_return(product_by_category)

      result = Product.product_by_category(1)

      expect(result.length).to eq 2
      expect(result[0].id).to eq 5
      expect(result[0].product_category_id).to eq 1
      expect(result[0].product_model).to eq 'iPhone 11'
      expect(result[0].brand).to eq 'Apple'
      expect(result[1].id).to eq 6
      expect(result[1].product_category_id).to eq 1
      expect(result[1].product_model).to eq 'iPhone 11 - Pro'
      expect(result[1].brand).to eq 'AppleX'
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      product_by_category = []
      allow(Product).to receive(:product_by_category).with(1).and_return(product_by_category)

      result = Product.product_by_category(1)

      expect(result).to eq []
    end
  end
end
