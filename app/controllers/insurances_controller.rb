class InsurancesController < ApplicationController
  before_action :params_product_id, only: %i[index show]
  def index
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}/packages")
    @packages = JSON.parse(response.body)
    redirect_to root_path, alert: t(:unable_to_load_package_information) if @packages.nil?
  end

  def show
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}")
    @product = JSON.parse(response.body)
    @id = params[:id]
    @insurance = Insurance.find(@product_id, @id)
    redirect_to root_path, alert: t(:unable_to_load_package_information) if @insurance.nil?
  end

  private

  def params_product_id
    @product_id = params[:product_id]
  end
end
