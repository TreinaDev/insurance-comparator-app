class ClientsController < ApplicationController
  before_action :authenticate_client!

  def profile
    @client = current_client
  end
end
