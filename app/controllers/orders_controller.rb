class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @equipment = Equipment.where(id: @order.equipment_id)
  end

  def new
    @equipment = Equipment.where(client_id: current_client)
    @insurance = Insurance.find(params[:insurance_id])
    p @insurance
    @order = Order.new
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif current_client.equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  def create
    insurance = Insurance.find(params[:insurance_id])
    @order = Order.new(order_params)
    @order.client = current_client
    @order.assign_insurance_to_order(insurance)
    @order.validate_cpf(current_client().cpf)
    if @order.save && @order.insurance_company_approval?
      return redirect_to order_path(@order.id), notice: t(:your_order_is_being_processed)
    end
    rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = t(:your_order_was_not_registered)
    render :action => "new", :id => insurance
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:equipment_id, :contract_period)
  end
end