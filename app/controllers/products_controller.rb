class ProductsController < ApplicationController
  def index
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products")
    @product_model = JSON.parse(response.body)

    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
    @product_categories = JSON.parse(response.body)

    @exibir = []
    @product_categories.each do |product_category|
      @product_model.each do |product|
        if product_category['id'] == product['product_category_id']
          @exibir << product
        end
      end
    end
  end

  def search
    @query = params[:query]
    @products = Product.search(@query)
  end
end
