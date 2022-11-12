class PaymentOption
  attr_accessor :payment_method_id, :payment_method_name, :tax_percentage, :tax_maximum, :max_installments,
                :single_installment_discount, :payment_method_status

  def initialize(payment_method_id:, payment_method_name:, tax_percentage:, tax_maximum:, max_installments:,
                 single_installment_discount:, payment_method_status:)
    @payment_method_id = payment_method_id
    @payment_method_name = payment_method_name
    @tax_percentage = tax_percentage
    @tax_maximum = tax_maximum
    @max_installments = max_installments
    @single_installment_discount = single_installment_discount
    @payment_method_status = payment_method_status
  end

  def self.all
    payment_options = []
    response = Faraday.get('https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        payment_options << PaymentOption.new(payment_method_id: d['payment_method_id'],
                                             payment_method_name: d['payment_method_name'],
                                             tax_percentage: d['tax_percentage'], tax_maximum: d['tax_maximum'],
                                             max_installments: d['max_installments'],
                                             single_installment_discount: d['single_installment_discount'],
                                             payment_method_status: d['payment_method_status'])
      end
    end
    payment_options
  end
end
