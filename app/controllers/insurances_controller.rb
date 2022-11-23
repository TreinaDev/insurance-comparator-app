class InsurancesController < ApplicationController

  def index
    id = params[:product_category_id]
    @insurances = Insurance.find(id)
    redirect_to root_path, alert: t(:unable_to_load_package_information) if @insurances.nil?
  end

  def show

  end
end
