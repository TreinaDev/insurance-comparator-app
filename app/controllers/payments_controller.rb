class PaymentsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: %i[new create]

  def new
    @payment = Payment.new
    @payment_options = PaymentOption.all(@order.insurance_company_id)
  end

  def create
    @payment = Payment.new(payment_params)
    set_payment_informations
    if @payment.save
      @order.update!(payment_method: @payment.payment_method_id, status: :charge_pending)
      @payment.request_payment
      redirect_to @order, notice: I18n.t('payment_created')
    else
      @payment_options = PaymentOption.all(@order.insurance_company_id)
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

  def set_payment_informations
    @payment.client = current_client
    @payment.order = @order
    @payment.payment_description = PaymentOption.find(@payment.payment_method_id).formatted_payment_type_and_name
  end
end
