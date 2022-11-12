class OrdersController < ApplicationController
  def show
    # código da aline e thalis

    # @client = cliente da compra / usuário current_user?

    # issue API - Verifica CPF
    if @order.insurance_approved? # -> perguntamos se o status da compra é aprovada pela seguradora
      @order.validate_cpf # -> chamamos o método que valida o CPF -> esse método fica dentro do MODEL
      # -> esse método altera o status da compra para cpf.approved ou cpf.disapproved
    end

    # issue API - Disponibiliza emissão de cobrança
    if @order.cpf_approved? # -> perguntamos se o status da compra está como CPF aprovado
      @order.validade_charge # -> chamamos o método que manda a compra pra app de Cobrança -> método fica dentro do MODEL
    end

    if @order.cpf_disapproved?
      # aqui a compra não continua / Cliente consegue ver no status da compra que seu CPF está bloqueado
      # dentro da VIEW colocamos uma mensagem para o Cliente (if @order.cpf_disapproved?)
    end

    if @order.charge_pending?
    end

    if @order.charge_approved?
    end
  end
end
