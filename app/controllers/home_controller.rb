class HomeController < ApplicationController
  def index; end

  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end

  def show 
    id = params[:id]
    response = Faraday.get("http://localhost:4000/api/v1/insurance/#{id}")
    if response.success?
      @insurance = JSON.parse(response.body)
    else
      redirect_to search_path, notice: 'Não foi possível carregar as informações do pacote'
    end
  end
end
