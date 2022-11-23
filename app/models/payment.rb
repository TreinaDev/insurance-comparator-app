class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :order

  enum status: { pending: 0, approved: 5, refused: 10 }
  validates :parcels, numericality: { greater_than_or_equal_to: 1 }, allow_blank: true

  validates :parcels, :payment_method_id, presence: true
  validates :invoice_token, presence: true, if: :approved?
  validate :parcels_is_less_than_or_equal_to_max_parcels

  def parcels_is_less_than_or_equal_to_max_parcels
    payment_option = PaymentOption.find(payment_method_id)
    return unless parcels.present? && payment_option.present? && parcels > payment_option.max_parcels

    errors.add(:parcels, ' não pode ser maior que o máximo permitido pelo meio de pagamento')
  end

  def request_payment
    data = { invoice: { payment_method_id: payment_method_id, order_id: order.id, registration_number: client.cpf,
             package_id: order.insurance_id, insurance_company_id: 1, voucher: '', parcels: 0,
             final_price: order.total_price }}
    response = Faraday.post("#{Rails.configuration.external_apis['payment_options_api']}/invoices",
                            data.to_json, "Content-Type" => "application/json")

    return JSON.parse(response.body) if response.success?
  end
end
