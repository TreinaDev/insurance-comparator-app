class ProductsController < ApplicationController
  def show
    id = params[:id]
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/product_categories/#{id}/products")
    @products = JSON.parse(response.body)
  end

  def search
    @query = params[:query]
    @products = Product.search(@query)
  end
end
