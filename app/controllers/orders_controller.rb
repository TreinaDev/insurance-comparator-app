class OrdersController < ApplicationController
  def index
    @client = current_client
    @orders = Order.all
    @orders.each do |order|
      order.validate_cpf(order) if order.insurance_approved?

      # issue API - Disponibiliza emissão de cobrança
      if order.cpf_approved? # -> perguntamos se o status da compra está como CPF aprovado
        order.validade_charge # -> chamamos o método que manda a compra pra app de Cobrança -> método fica dentro do MODEL
      end

      if order.cpf_disapproved?
        # aqui a compra não continua / Cliente consegue ver no status da compra que seu CPF está bloqueado
        # dentro da VIEW colocamos uma mensagem para o Cliente (if order.cpf_disapproved?)
      end

      # if order.charge_pending?
      # end

      # if order.charge_approved?
      # end

      def cpf_approved
        order.cpf_approved!
      end

      def cpf_disapproved
        order.cpf_disapproved!
      end
    end
  end
end
