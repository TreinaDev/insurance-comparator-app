class PaymentOptionsController < ApplicationController
  def new
    @payment_options = PaymentOption.all
    @order = Order.find(params[:order_id])
  end

  def create; end
end
