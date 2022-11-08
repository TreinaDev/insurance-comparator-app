class HomeController < ApplicationController
  def index; end

  def search
    @query = params[:query]
    @insurances = Insurance.search(@query)
  end
end
