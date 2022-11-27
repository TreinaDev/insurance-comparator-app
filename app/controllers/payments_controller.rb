class PaymentsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: %i[new create]
  before_action :set_payment_params, only: %i[create]

  def new
    @payment = Payment.new
    @payment_options = PaymentOption.all(@order.insurance_company_id)
  end

  def create
    if @payment.save && @payment.request_payment
      @order.update!(payment_method: @payment.payment_method_id, status: :charge_pending)
      redirect_to @order, notice: t(:payment_created)
    elsif @payment.valid?
      redirect_to @order, alert: t(:system_fail)
    else
      @payment_options = PaymentOption.all(@order.insurance_company_id)
      flash.now[:alert] = t(:payment_not_created)
      render :new
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:parcels, :payment_method_id, :order_id)
  end

  def set_payment_params
    @payment = Payment.new(payment_params)
    @payment.client = current_client
    @payment.order = @order
    @payment.payment_description = PaymentOption.find(@order.insurance_company_id, @payment.payment_method_id).formatted_payment_type_and_name
  end
end
