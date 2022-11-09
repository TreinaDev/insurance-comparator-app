class ClientsController < ApplicationController
  before_action :authenticate_client!

  def show; end
end
