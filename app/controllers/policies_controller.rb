class PoliciesController < ApplicationController
  def index
    order_id = params[:order_id]
    @order = Order.find(order_id)
    @policy = Policy.find(order_id)
  end

  def cancel_policy
    order_id = params[:order_id]
    policy_code = params[:id]
    @order = Order.find(params[:order_id])
    Policy.cancel(policy_code, order_id)
  end
end
