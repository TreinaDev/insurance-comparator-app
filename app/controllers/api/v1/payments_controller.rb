class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :set_payment, only: %i[show]
  before_action :set_order, only: %i[approved]
  before_action :payment_params, only: %i[approved]

  def show
    return render status: :ok, json: create_json(@payment) if @payment.present?

    raise ActiveRecord::RecordNotFound
  end

  def approved
    if payment_params[:status] == 'approved'
      if @payment.update(payment_params)
        @order.approve_charge
        render status: :ok, json: create_json(@payment)
      else
        render status: :precondition_failed, json: { errors: @payment.errors.full_messages }
      end
    else
      render status: :not_acceptable, json: {}
    end
  end

  def refused
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

  def set_payment
    @payment = Payment.find(params[:order_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:status, :invoice_token)
  end
end
