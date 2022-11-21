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
  def voucher # dentro do payment controller
    @payment = Payment.find(params[:payment_id])

    order_id = @payment.order_id
    @order = Order.find(order_id)

    @voucher = params[:voucher].upcase
    @id = @order.product_model_id
    @price = @order.final_price

    @payment.voucher_validation
  end

  def voucher_validation # dentro do payment model
    voucher_params = { id: @id, voucher: @voucher, price: @price }.to_query

    response = Faraday.get("#{Rails.configuration.external_apis['payment_options_api']}/promos/#{voucher_params}")
    return unless response.success?

    data = JSON.parse(response.body)
    case data['status']
    when 'Cupom expirado'
      render 'new', alert: 'Cupom expirado'
    when 'Cupom inválido'
      render 'new', alert: 'Cupom inválido'
    when 'Cupom válido'

      @order.voucher_name = @voucher
      @order.voucher = data['discount']
      @order.save!

      render 'new', notice: 'Cupom inserido com sucesso'
    end
  end
  # rubocop:enable Metrics/methodLength

  def calculate_price
    equipment_price = equipment.equipment_price
    self.total_price = (((price_percentage * equipment_price) / 100) * contract_period)
  end
end
