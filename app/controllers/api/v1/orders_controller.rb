class Api::V1::OrdersController < Api::V1::ApiController

  def show
		order = Order.find(params[:id])
		equipment = Equipment.find(order.equipment_id)
		client = Client.find(order.client_id)
		order_api = OrderApi.new(order, equipment, client)
    render status: :ok, json: order_api.as_json
  end
end



