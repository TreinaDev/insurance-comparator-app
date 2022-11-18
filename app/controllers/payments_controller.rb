class PaymentsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: %i[new create]

    def new
      @payment = Payment.new
      @payment_options = PaymentOption.all
    end
  
    def create
      @client = current_client
    end

    private

    def set_order
      @order = Order.find(params[:order_id])
    end

    def payment_params
      params.require(:payment).permit(:parcels, :payment_method_id)
    end
end
  