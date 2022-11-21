class HomeController < ApplicationController
  def index
    response = Faraday.get('https://6376b6f9b5f0e1eb8511f710.mockapi.io/api/v1/insurances/product_categories')
    @product_categories = JSON.parse(response.body)
  end

end