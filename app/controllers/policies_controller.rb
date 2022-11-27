class PoliciesController < ApplicationController
  def index
    order_id = params[:order_id]
    @order = Order.find(order_id)
    @policy = Policy.find(order_id)
  end
end
