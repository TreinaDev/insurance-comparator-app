class HomeController < ApplicationController

  def index; end

  def search
    @insurances = Insurance.all
    @insurance = Insurance.find_by('product_model LIKE ?', "%#{params[query]}%")
  end
end