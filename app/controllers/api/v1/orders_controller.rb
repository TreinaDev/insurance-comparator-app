class Api::V1::OrdersController < Api::V1::ApiController
  before_action :fetch_order

  def show
    order = Order.find(params[:id])
    Equipment.find(order.equipment_id)
    Client.find(order.client_id)
    render status: :ok, json: order.as_json(include: { equipment: { except: %i[created_at updated_at client_id id] },
                                                       client: { except: %i[created_at updated_at id] } },
                                            except: %i[created_at updated_at equipment_id client_id])
  end

  def payment_approved
    @order.charge_approved!
    render status: :ok, json: { message: 'success' }.to_json
  end

  def payment_refused
    @order.charge_refused!
    render status: :ok, json: { message: 'success' }.to_json
  end

  private

  def fetch_order
    @order = Order.find params[:id]
  end
end
