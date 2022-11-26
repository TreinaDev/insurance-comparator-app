class Api::V1::OrdersController < Api::V1::ApiController
  before_action :fetch_order_and_payment
  before_action :order_params, only: %i[insurance_approved insurance_disapproved]

  def show
    @order.equipment
    @order.client
    render status: :ok, json: create_json(@order)
  end

  def insurance_approved
    if order_params[:status] == 'insurance_approved'
      if @order.update(order_params)
        render status: :ok, json: create_json(@order)
      else
        render status: :precondition_failed, json: { errors: @order.errors.full_messages }
      end
    else
      render status: :not_acceptable, json: {}
    end
  end

  def insurance_disapproved
    if order_params[:status] == 'insurance_disapproved'
      if @order.update(order_params)
        render status: :ok, json: create_json(@order)
      else
        render status: :precondition_failed, json: { errors: @order.errors.full_messages }
      end
    else
      render status: :not_acceptable, json: {}
    end
  end

  def create_json(order)
    order.as_json(include: { equipment: { except: %i[created_at updated_at client_id id] },
                             client: { except: %i[created_at updated_at id] } },
                  except: %i[created_at updated_at equipment_id client_id])
  end

  def payment_approved
    if invoice_token?
      @order.charge_approved!
      @payment.invoice_token = params['transaction_registration_number']
      @payment.approved!
      return render status: :ok, json: { message: 'success' }
    end
    @payment.errors.add(:invoice_token, 'não pode ficar em branco')
    render status: :precondition_failed, json: { message: 'failure',
                                                 error: @payment.errors.first.full_message }
  end

  def payment_refused
    @order.charge_refused!
    @payment.refused!
    render status: :ok, json: { message: 'success' }
  end

  private

  def order_params
    params.require(:order).permit(:policy_code, :policy_id, :status)
  end

  def fetch_order_and_payment
    @order = Order.find params[:id]
    @payment = @order.payment
  end

  def invoice_token?
    params['transaction_registration_number'].present?
  end
end
