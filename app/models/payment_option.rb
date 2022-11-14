# rubocop:disable Metrics/ParameterLists
# rubocop:disable Layout/LineLength

class PaymentOption
  attr_accessor :payment_method_id, :payment_method_name, :max_installments, :tax_percentage, :tax_maximum,
                :single_installment_discount, :payment_method_status

  def initialize(payment_method_id:, payment_method_name:, max_installments:, tax_percentage:, tax_maximum:,
                 single_installment_discount:, payment_method_status:)
    @payment_method_id = payment_method_id
    @payment_method_name = payment_method_name
    @max_installments = max_installments
    @tax_maximum = tax_maximum
    @tax_percentage = tax_percentage
    @single_installment_discount = single_installment_discount
    @payment_method_status = payment_method_status
  end

  def self.all
    payment_options = []
    response = Faraday.get('https://64eae736-af28-4f96-a564-c1c397f6afcb.mock.pstmn.io/api/v1/company_payment_options')
    if response.success? 
      data = JSON.parse(response.body)
      data.each do |d|
        payment_options << PaymentOption.new(payment_method_id: d['payment_method_id'], payment_method_name: d['payment_method_name'],
                                             max_installments: d['max_installments'], tax_percentage: d['tax_percentage'],
                                             tax_maximum: d['tax_maximum'], payment_method_status: d['payment_method_status'],
                                             single_installment_discount: d['single_installment_discount'])
      end
    end; payment_options
  end
end

# rubocop:enable Metrics/ParameterLists
# rubocop:enable Layout/LineLength
