class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]

  def index
    @orders = Order.all
  end

  def show
    @equipment = Equipment.find(@order.equipment_id)
  end

  def new
    @insurance = Insurance.find(params[:insurance_id])
    @order = Order.new
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif current_client.equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  def create
    @client = current_client
    @order = Order.new(order_params)
    set_insurance_and_client
    if @order.save
      @order.validate_cpf(@client.cpf) if @order.pending?
      return redirect_to order_path(@order),
                         notice: t(:your_order_is_being_processed)
    end

    flash.now[:alert] = t(:your_order_was_not_registered)
    render :new
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:equipment_id, :contract_period)
  end

  def set_insurance_and_client
    @insurance = Insurance.find(params[:insurance_id])
    @order.insurance_id = @insurance.id
    @order.price_percentage = @insurance.price
    @order.insurance_name = @insurance.insurance_name
    @order.packages = @insurance.packages
    @order.insurance_model = @insurance.product_model
    @order.client = current_client
  end
end
