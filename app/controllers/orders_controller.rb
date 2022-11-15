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
    @order.client = current_client
    if @order.save
      redirect_to @order, notice: t('Seu pedido está em análise pela seguradora')
    else
      render :new, alert: t('Não foi possível cadastrar o pedido')
    end
  end

  private

  def order_params
    params.require(:order).permit(:equipment_id, :payment_option, :contract_period)
  end
end
