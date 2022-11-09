class HomeController < ApplicationController
  def index; end

  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show
    @insurance = Insurance.find(params[:id])
     p @insurance
     if @insurance.nil?
      redirect_to search_path, notice: 'Não foi possível carregar as informações do pacote'
    end
  end
end
