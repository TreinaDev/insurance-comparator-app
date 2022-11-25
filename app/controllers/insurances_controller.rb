class InsurancesController < ApplicationController
  def index
    @product_id = params[:product_id]
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}/packages")
    @packages = JSON.parse(response.body)
    redirect_to root_path, alert: t(:unable_to_load_package_information) if @packages.nil?
  end

  def show
    @product_id = params[:product_id]
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}")
    @product = JSON.parse(response.body)
    @id = params[:id]
    response2 = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/
                            #{@product_id}/packages/#{@id}")
    @insurance = JSON.parse(response2.body)
  end
end
