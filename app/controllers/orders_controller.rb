class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]

  def index
    @orders = Order.all
  end

  def show
<<<<<<< HEAD
    @order = Order.find(params[:id])
    @equipment = Equipment.where(id: @order.equipment_id)
=======
    @equipment = Equipment.find(@order.equipment_id)
>>>>>>> main
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
    @client = current_client
    @order = Order.new(order_params)
    set_insurance_and_client
    if @order.save
      return redirect_to insurance_order_path(@insurance.id, @order),
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

  def set_coverage
    Faraday.get("https://d946210b-806a-47b9-ad2f-4a1d9b6c8852.mock.pstmn.io/api/v1/package_coverages")
    
  end
end

# @id = id
#     @name = name
#     @max_period = max_period
#     @min_period = min_period
#     @id = id
#     @insurance_name = insurance_name
#     @price = price
#     @product_category_id = product_category_id
#     @product_category = product_category
#     @product_model = product_model