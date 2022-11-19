class OrdersController < ApplicationController
  before_action :authenticate_client!

  def show
    @order = Order.find(params[:id])
    @equipment = Equipment.find(@order.equipment_id)
  end

  def new
    @equipment = Equipment.all
    p @equipment
    p "AAAAAAA #{params[:insurance_id]}"
    @insurance = Insurance.find(params[:insurance_id])
    puts "======================"
    p @insurance
    puts "======================"
    @order = Order.new
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif current_client.equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  def create
    @order = Order.new(order_params)
    set_insurance_and_client
    if @order.save
      return redirect_to insurance_order_path(@insurance, @order),
                         notice: t(:your_order_is_being_processed)
    end

    flash.now[:alert] = t(:your_order_was_not_registered)
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:equipment_id, :contract_period)
  end

  def set_insurance_and_client
    @insurance = Insurance.find(params[:insurance_id])
    @order.package_name = @insurance.name
    @order.insurance_name = @insurance.insurance_name
    @order.id = @insurance.id
    @order.max_period = @insurance.max_period
    @order.min_period = @insurance.min_period
    @order.product_category_id = @insurance.product_category_id
    @order.product_category = @insurance.product_category
    @order.product_model = @insurance.product_model
    @order.price = @insurance.price
    @order.client = current_client
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