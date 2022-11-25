class Api::V1::OrdersController < Api::V1::ApiController
  before_action :fetch_order_and_payment

  def show
    order = Order.find(params[:id])
    Equipment.find(order.equipment_id)
    Client.find(order.client_id)
    render status: :ok, json: order.as_json(include: { equipment: { except: %i[created_at updated_at client_id id] },
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

  def fetch_order_and_payment
    @order = Order.find params[:id]
    @payment = @order.payment
  end

  def invoice_token?
    params['transaction_registration_number'].present?
  end
end
