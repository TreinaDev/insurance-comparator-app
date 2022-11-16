class OrdersController < ApplicationController
  before_action :authenticate_client!

  def index
    @client = current_client
    @orders = Order.all
    @orders.each do |order|
      order.validate_cpf if order.insurance_approved?
    end
  end
end
