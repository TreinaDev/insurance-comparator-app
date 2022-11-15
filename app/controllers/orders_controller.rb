class OrdersController < ApplicationController
  def index
    @client = current_client
    @orders = Order.all
    @orders.each do |order|
      order.validate_cpf(order) if order.insurance_approved?

      # issue API - Disponibiliza emissão de cobrança
      order.validade_charge(order) if order.cpf_approved? 

      #Verificar se não podemos substituir o status "CPF Aprovado" por Pagamento em Processamento, uma vez que, se o cpf está aprovado, o pagamento já se torna pendente de aprovação.

      # if order.cpf_disapproved?
      #   # aqui a compra não continua / Cliente consegue ver no status da compra que seu CPF está bloqueado
      #   # dentro da VIEW colocamos uma mensagem para o Cliente (if order.cpf_disapproved?)
      # end

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
