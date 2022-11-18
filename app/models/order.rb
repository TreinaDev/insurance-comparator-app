class Order < ApplicationRecord
  belongs_to :equipment
  belongs_to :client
  before_save :calculate_price
  validates :contract_period, presence: true
  validates :contract_period, comparison: { greater_than: 0 }, allow_blank: true
  enum status: { pending: 0, insurance_company_approval: 2, insurance_approved: 3, cpf_disapproved: 6,
                 charge_pending: 9, charge_approved: 12 }
  # enum payment_method: { credit_card: 4, pix: 8, boleto: 12 }

  def validate_cpf(client_cpf)
    response = Faraday.get("https://localhost:5000/api/v1/verifica_cpf/#{client_cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    if data['blocked'] == 'true'
      cpf_disapproved!
    else
      insurance_company_approval!
    end
  end

  # rubocop:disable Metrics/methodLength
  def validate_coupon
    @id = order.product_model_id
    @voucher = params[:coupon].upcase
    @preco = order.final_price
    response = Faraday.get("https://localhost:5000/api/v1/promos/#{@id}-#{@voucher}-#{@preco}")
    return unless response.success?

    data = JSON.parse(response.body)
    case data['status']
    when 'Cupom expirado'
      flash.now[:alert] = 'Cupom expirado'
      render 'new'
    when 'Cupom inválido'
      flash.now[:alert] = 'Cupom inválido'
      render 'new'
    when 'Cupom válido'
      flash.now[:notice] = 'Cupom válido'
      @discount = data['discount']
      render 'new'
    end
  end
  # rubocop:enable Metrics/methodLength

  def calculate_price
    equipment_price = equipment.equipment_price
    self.total_price = (((price_percentage * equipment_price) / 100) * contract_period)
  end
end
