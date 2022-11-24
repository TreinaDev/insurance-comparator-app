class Api::V1::OrdersController < Api::V1::ApiController
  def show
    order = Order.find(params[:id])
    Equipment.find(order.equipment_id)
    Client.find(order.client_id)
    render status: :ok, json: order.as_json(include: { equipment: { except: %i[created_at updated_at client_id id] },
                                                       client: { except: %i[created_at updated_at id] } },
                                            except: %i[created_at updated_at equipment_id client_id])
  end
end
