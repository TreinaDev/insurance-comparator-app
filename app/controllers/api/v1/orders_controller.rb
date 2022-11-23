class Api::V1::OrdersController < Api::V1::ApiController
  before_action :fetch_order

  def payment_approved
    @order.charge_approved!
    render status: :ok, json: { message: 'success' }.to_json
  end

  def payment_refused
    @order.charge_refused!
    render status: :ok, json: { message: 'success' }.to_json
  end

  private

  def fetch_order
    @order = Order.find params[:id]
  end
end
