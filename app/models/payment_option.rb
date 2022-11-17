# rubocop:disable Metrics/ParameterLists
# rubocop:disable Layout/LineLength

class PaymentOption
  attr_accessor :name, :payment_type, :tax_percentage, :tax_maximum,
                :max_parcels, :single_parcel_discount

  def initialize(name:, payment_type:, tax_percentage:, tax_maximum:, max_parcels:,
                 single_parcel_discount:)
    @name = name
    @payment_type = payment_type
    @tax_maximum = tax_maximum
    @tax_percentage = tax_percentage
    @max_parcels = max_parcels
    @single_parcel_discount = single_parcel_discount
  end

  def self.all
    payment_options = []
    response = Faraday.get('http://localhost:5000/api/v1/insurance_companies/1/payment_options')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        payment_options << PaymentOption.new(name: d['name'], payment_type: d['payment_type'],
                                             tax_percentage: d['tax_percentage'], tax_maximum: d['tax_maximum'],
                                             max_parcels: d['max_parcels'], single_parcel_discount: d['single_parcel_discount'])
      end
    end; payment_options
  end

  def formatted_payment_type_and_name
    "#{payment_type} - #{name}"
  end
end

# rubocop:enable Metrics/ParameterLists
# rubocop:enable Layout/LineLength
