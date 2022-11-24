class Api::V1::OrdersController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
  def insurance_approved
    id = params[:id]
    order = Order.find(id)
    order.update!(status: :insurance_approved)

    render status: :created, json: "{ status: #{order.status} }"
  end

  def insurance_disapproved
    id = params[:id]
    order = Order.find(id)
    render status: :created
    order.update!(status: :insurance_disapproved)

    render status: :created, json: "{ status: #{order.status} }"
  end

  private

  def internal_server_error
    render status: :internal_server_error
  end
end
