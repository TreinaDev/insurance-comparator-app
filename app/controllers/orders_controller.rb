class OrdersController < ApplicationController
  before_action :authenticate_client!
  before_action :set_order, only: [:show]
  before_action :set_insurance, only: %i[new]
  before_action :set_product_id, only: %i[new create]

  def index
    @orders = current_client.orders
  end

  def show
    @equipment = @order.equipment
  end

  def new
    @equipment = Equipment.where(product_category_id: @insurance.product_category_id, client: current_client)
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
    set_product_id
    set_insurance
    set_product_id
    assign_order_variables
    if @order.validate_cpf(@order.client.cpf) && @order.valid?
      @order.save
      unless @order.post_policy
        flash.now[:alert] = t(:fail_connection_api)
        return redirect_to order_path(@order.id)
      end
      redirect_to order_path(@order.id), notice: t(:your_order_is_being_processed)
    else
      @equipment = Equipment.where(product_category_id: @insurance.product_category_id, client: current_client)
      flash.now[:alert] = t(:your_order_was_not_registered)
      render :new
    end
  rescue Errno::ECONNREFUSED
    flash.now[:alert] = t(:fail_connection_api)
    redirect_to root_path
  end

  def voucher
    @order = Order.find(params[:id])
    @voucher = params[:voucher].upcase
    v_params = { product_id: @order.product_model_id, price: @order.final_price }.to_query
    response = Faraday.get("#{Rails.configuration.external_apis['payment_fraud_api']}/promos/#{@voucher}/?#{v_params}")
    if response.success?
      data = JSON.parse(response.body)
      case data['status']
      when 'Cupom expirado.'
        redirect_to new_order_payment_path(@order), alert: t(:expired_coupon)

      when 'Cupom inválido.'
        redirect_to new_order_payment_path(@order), alert: t(:invalid_coupon)

      when 'Cupom válido.'
        @order.voucher_code = @voucher
        @order.voucher_price = data['discount'].to_f
        @order.save!
        redirect_to new_order_payment_path(@order), notice: t(:valid_coupon)
      end
    else
      redirect_to new_order_payment_path(@order), alert: t(:invalid_coupon)
      @order.update(voucher_code: nil)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def assign_order_variables
    @order = Order.new(order_params)
    @order.client = current_client
    @order.assign_insurance_to_order(@insurance)
    @order.validate_cpf(@order.client.cpf)
    @order.product_model_id = @product_id
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
    set_insurance
    @product_id = params[:product_id]
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products/#{@product_id}")
    @product = JSON.parse(response.body)
    @insurance.product_model = @product['product_model']
  end
end
