class HomeController < ApplicationController
  def index
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products")
    @product_model = JSON.parse(response.body)
    
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/product_categories")
    @product_categories = JSON.parse(response.body)
  end

end