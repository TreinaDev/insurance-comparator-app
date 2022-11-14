class OrdersController < ApplicationController
  # before_action :authenticate_client!

  def new
    get_insurance
    @order = Order.new
    @devices = Equipment.all
    @payment_methods = PaymentOption.all
    p @payment_methods
    @period = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end

  def create
    
  end

  private
  def get_insurance
    id = params[:id]
    @insurance = Insurance.find(id)
    if @insurance.nil?
      return redirect_to root_path, alert: t(:unable_to_load_package_information) 
    end
  end

  def order_params
    # params.require(:order).permit(:product_id, :client_id, :status, :payment_method, :contract_period :contract_price, :coverage)
  end
end

