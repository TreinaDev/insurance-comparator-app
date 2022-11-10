class InsurancesController < ApplicationController
  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show
    @id = params[:id]
    @insurance = Insurance.find(@id)
    return redirect_to search_path, notice: 'Não foi possível carregar as informações do pacote' if @insurance.nil?
  end
end
