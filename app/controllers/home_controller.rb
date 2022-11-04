class HomeController < ApplicationController
  def index; end

  def search
    @query = params[:query]
    @insurances = Insurance.search
  end
end
