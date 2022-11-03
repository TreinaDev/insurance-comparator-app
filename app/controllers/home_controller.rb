class HomeController < ApplicationController
  def index
    @client = Client.find(1)
  end
end