class OrdersController < ApplicationController
  before_action :authenticate_client!

  def index
    @client = current_client
    @orders = Order.all
    @orders.each do |order|
      order.validate_cpf(order) if order.insurance_approved?

      # issue API - Disponibiliza emissão de cobrança
      # order.validade_charge(order) if order.charge_pending?

      # if order.cpf_disapproved?
      #   # aqui a compra não continua / Cliente consegue ver no status da compra que seu CPF está bloqueado
      #   # dentro da VIEW colocamos uma mensagem para o Cliente (if order.cpf_disapproved?)
      # end

      # if order.charge_pending?
      # end

      # if order.charge_approved?
      # end
    end
  end
end
