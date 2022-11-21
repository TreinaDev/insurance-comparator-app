class ProductModelController < ApplicationController
  def index
    # response = Faraday.get('https://6376b6f9b5f0e1eb8511f710.mockapi.io/api/v1/insurances/product_categories')
    # product_categories = JSON.parse(response.body)
    # @product_category = []
    # product_categories.each do |pc|
    #     @product_category << pc['name']
    # end
    # @product_category

    response = Faraday.get('http://localhost:4000/api/v1/products')
    @product_model = JSON.parse(response.body)
  end
end