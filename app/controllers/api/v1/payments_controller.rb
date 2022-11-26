class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :set_payment, only: %i[show]

  def show
    return render status: :ok, json: create_json(@payment) if @payment.present?

    raise ActiveRecord::RecordNotFound
  end

  private

  def create_json(payment)
    payment.as_json(except: %i[created_at updated_at client_id],
                    include: { client: { only: :cpf },
                               order: { only: %i[insurance_company_id total_price insurance_id] } })
  end

  def set_payment
    @payment = Payment.find(params[:order_id])
  end
end
