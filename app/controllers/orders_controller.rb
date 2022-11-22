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
    set_insurance_id
    @order = Order.new
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif current_client.equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  def create
    client_cpf = current_client.cpf
    @order = Order.new(order_params)
    set_insurance_and_client
    @order.validate_cpf(client_cpf)
    p @order
    if @order.save && @order.insurance_company_approval? 
      return redirect_to order_path(@order.id), notice: t(:your_order_is_being_processed)
    end
      flash.now[:alert] = t(:your_order_was_not_registered)
      set_insurance_id
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
    set_insurance_id
    @order.package_name = @insurance.name
    @order.insurance_name = @insurance.insurance_name
    @order.insurance_company_id = @insurance.insurance_company_id
    @order.max_period = @insurance.max_period
    @order.min_period = @insurance.min_period
    @order.product_category_id = @insurance.product_category_id
    @order.product_category = @insurance.product_category
    @order.product_model = @insurance.product_model
    @order.price = @insurance.price
    @order.client = current_client
  end

  def set_insurance_id
    @insurance = Insurance.find(params[:insurance_id])
  end
end