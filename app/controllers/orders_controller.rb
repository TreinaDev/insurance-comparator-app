class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]
  before_action :set_insurance, only: %i[new]
  before_action :set_product_id, only: %i[new create]

  def index
    @orders = Order.all
  end

  def show
    @equipment = @order.equipment
  end

  def new
    @equipment = current_client.equipment
    @order = Order.new
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif @equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def create
    set_insurance
    assign_order_variables
    if @order.validate_cpf(@order.client.cpf) && @order.valid?
      @order.save
      unless @order.post_policy
        flash.now[:alert] = t(:fail_connection_api)
        return redirect_to order_path(@order.id)
      end
      redirect_to order_path(@order.id), notice: t(:your_order_is_being_processed)
    else
      flash.now[:alert] = t(:your_order_was_not_registered)
      render :new
    end
  rescue Errno::ECONNREFUSED
    flash.now[:alert] = t(:fail_connection_api)
    redirect_to root_path
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def assign_order_variables
    @order = Order.new(order_params)
    @order.client = current_client
    @order.assign_insurance_to_order(@insurance)
    @order.validate_cpf(@order.client.cpf)
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_insurance
    @insurance = Insurance.find(params[:product_id], params[:insurance_id])
  end

  def order_params
    params.require(:order).permit(:equipment_id, :contract_period)
  end

  def set_product_id
    @product_id = params[:product_id]
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}")
    @product = JSON.parse(response.body)
  end

  def throw_error
    flash.now[:alert] = t(:your_order_was_not_registered)
    render :new
  end
end
