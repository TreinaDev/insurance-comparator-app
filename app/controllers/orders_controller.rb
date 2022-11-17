class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]

  def index
    @orders = Order.all
  end

  def show
    @client = current_client
    @order.validate_cpf(@client.cpf) if @order.pending?
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
