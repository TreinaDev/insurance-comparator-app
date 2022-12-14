class PoliciesController < ApplicationController
  before_action :authenticate_client!

  def index
    @orders = Order.where(client_id: current_client.id)
                   .where(status: %w[charge_approved cancelled])
                   .where.not(policy_code: nil)
  end

  def show
    order_id = params[:order_id]
    @order = Order.find(order_id)
    @policy = Policy.find(order_id)
  end

  def cancel_policy
    order_id = params[:order_id]
    policy_code = params[:id]
    @order = Order.find(params[:order_id])
    Policy.cancel(policy_code, order_id)
    redirect_to order_path(@order), notice: t(:order_cancelled_with_success)
  end
end
