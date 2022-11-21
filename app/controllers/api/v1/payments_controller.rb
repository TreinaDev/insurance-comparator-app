class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :set_payment, only: %i[show update]

  def show
    return render status: :ok, json: create_json(@payment) if @payment.present?

    raise ActiveRecord::RecordNotFound
  end

  def update
    payment_params = params.require(:payment).permit(:status, :invoice_token)
    if @payment.update(payment_params)
      render status: :created, json: create_json(@payment)
    else
      render status: :precondition_failed, json: { errors: @payment.errors.full_messages }
    end
  end

  private

  def create_json(payment)
    payment.as_json(except: %i[created_at updated_at client_id],
                    include: { client: { only: :cpf },
                               order: { only: %i[insurance_company_id package_id total_price] } })
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end
end
