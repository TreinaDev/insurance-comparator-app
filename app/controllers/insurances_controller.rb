class InsurancesController < ApplicationController
  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show
    id = params[:id]
    @insurance = Insurance.find(id)
    if @insurance.empty?
      redirect_to search_path, notice: I18n.t('Unable to load package information')
    end
  end
end
