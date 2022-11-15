class OrdersController < ApplicationController
  before_action :authenticate_client!

  def show
    @order = Order.find(params[:id])
  end

  def new
    @insurance = Insurance.find(params[:insurance_id])
    @order = Order.new
    @payment_options = PaymentOption.all
    if @insurance.nil?
      redirect_to root_path, alert: t(:unable_to_load_package_information)
    elsif current_client.equipment.empty?
      redirect_to new_equipment_path, alert: t(:is_necessary_register_a_device_to_purchase_the_insurance)
    end
  end

  def create
    @order = Order.new(order_params)
    insurance = Insurance.find(params[:insurance_id])
    get_insurance
    @order.client = current_client
    @order.save
    if @order.valid?
      return redirect_to insurance_order_path(insurance, @order), notice: t('Seu pedido está em análise pela seguradora')
    end
    flash.now[:alert] = t('Não foi possível cadastrar o pedido')
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:client_id, :equipment_id, :payment_option, :contract_period, :insurance_id)
  end

  def get_insurance
    insurance = Insurance.find(params[:insurance_id])
    @order.insurance_id = insurance.id
    @order.contract_price = insurance.price
    @order.insurance_name = insurance.insurance_name
    @order.packages = insurance.packages
    @order.insurance_model = insurance.product_model
  end
end
