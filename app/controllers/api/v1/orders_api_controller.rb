class Api::V1::OrdersApiController < Api::V1::ApiController
  before_action :set_order_and_payment, only: %i[show payment_approved payment_refused]

  def show
    return render status: :ok, json: create_json(@payment) if @payment.present?

    raise ActiveRecord::RecordNotFound
  end

  def payment_approved
    payment_params = params.require(:payment).permit(:status, :invoice_token)

    if payment_params[:status] == 'approved'
      if @payment.update(payment_params)
        render status: :ok, json: create_json(@payment)
      else
        render status: :precondition_failed, json: { errors: @payment.errors.full_messages }
      end
    else
      render status: :not_acceptable, json: {}
    end
  end

  def payment_refused
    payment_params = params.require(:payment).permit(:status)

    if payment_params[:status] == 'refused'
      if @payment.update(payment_params)
        render status: :ok, json: create_json(@payment)
      else
        render status: :precondition_failed, json: { errors: @payment.errors.full_messages }
      end
    else
      render status: :not_acceptable, json: {}
    end
  end

  private

  def create_json(payment)
    payment.as_json(except: %i[created_at updated_at client_id],
                    include: { client: { only: :cpf },
                               order: { only: %i[insurance_company_id total_price insurance_id] } })
  end

  def set_order_and_payment
    @order = Order.find(params[:id])
    @payment = @order.payment
  end
end
