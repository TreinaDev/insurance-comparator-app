class PaymentsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: %i[new create]
  before_action :set_payment_params, only: %i[create]

  def new
    @payment = Payment.new
    @payment_options = PaymentOption.all(@order.insurance_company_id)
  end

  def create
    if @payment.valid? && @payment.request_payment
      @payment.save
      @order.update!(payment_method: @payment.payment_method_id, status: :charge_pending,
                      voucher_price: @order.voucher_price, voucher_code: @order.voucher_code)
      redirect_to @order, notice: t(:payment_created)
    elsif !@payment.valid?
      @payment_options = PaymentOption.all(@order.insurance_company_id)
      flash.now[:alert] = t(:payment_not_created)
      render :new
    else
      redirect_to @order, alert: t(:system_fail)
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
    @payment.payment_description = PaymentOption.find(@payment.payment_method_id).formatted_payment_type_and_name
  end
end
