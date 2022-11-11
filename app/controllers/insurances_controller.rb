class InsurancesController < ApplicationController
  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show
    @id = params[:id]
    @insurance = Insurance.find(@id)
    return unless @insurance.nil?

    redirect_to search_path, notice: I18n.t('It is not possible to register your equipment.')
  end
end
