class HomeController < ApplicationController
  def index
    @insurances = Insurance.all
  end

end
