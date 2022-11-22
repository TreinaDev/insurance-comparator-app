class InsurancesController < ApplicationController
  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show
    id = params[:id]
    @insurance = Insurance.find(id)
    redirect_to root_path, alert: t(:unable_to_load_package_information) if @insurance.nil?
  end
end
