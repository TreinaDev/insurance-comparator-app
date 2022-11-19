class PaymentsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: %i[new create]

  def new
    @payment = Payment.new
    @payment_options = PaymentOption.all
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.client = current_client
    @payment.order = @order
    if @payment.save
      @order.charge_pending!
      @payment.pending!
      @order.update!(payment_method: @payment.payment_method_id)
      redirect_to @order, notice: I18n.t('payment_created')
    else
      @payment_options = PaymentOption.all
      flash.now[:alert] = I18n.t('payment_not_created')
      render 'new'
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:parcels, :payment_method_id, :order_id)
  end
end
