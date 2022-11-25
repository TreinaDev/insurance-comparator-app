class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_order, only: %i[show insurance_approved insurance_disapproved]

  def show
    Equipment.find(@order.equipment_id)
    Client.find(@order.client_id)
    render status: :ok, json: create_json(@order)
  end

  def insurance_approved
    order_params = params.require(:order).permit(:policy_code, :policy_id, :status)

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
    order_params = params.require(:order).permit(:status)

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

  private

  def create_json(order)
    order.as_json(include: { equipment: { except: %i[created_at updated_at client_id id] },
                             client: { except: %i[created_at updated_at id] } },
                  except: %i[created_at updated_at equipment_id client_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def internal_server_error
    render status: :internal_server_error
  end
end
