# rubocop:disable Metrics/ParameterLists
# rubocop:disable Layout/LineLength

class PaymentOption
  attr_accessor :name, :payment_type, :tax_percentage, :tax_maximum,
                :max_parcels, :single_parcel_discount, :payment_method_id

  def initialize(name:, payment_type:, tax_percentage:, tax_maximum:, max_parcels:,
                 single_parcel_discount:, payment_method_id:)
    @payment_method_id = payment_method_id
    @name = name
    @payment_type = payment_type
    @tax_maximum = tax_maximum
    @tax_percentage = tax_percentage
    @max_parcels = max_parcels
    @single_parcel_discount = single_parcel_discount
  end

  # rubocop:disable Metrics/AbcSize
  def self.all(insurance_company_id)
    payment_options = []
    response = Faraday.get("#{Rails.configuration.external_apis['payment_options_api']}/insurance_companies/#{insurance_company_id}/payment_options")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        payment_options << PaymentOption.new(name: d['name'], payment_type: d['payment_type'], max_parcels: d['max_parcels'],
                                             tax_percentage: d['tax_percentage'], tax_maximum: d['tax_maximum'],
                                             single_parcel_discount: d['single_parcel_discount'], payment_method_id: d['payment_method_id'])
      end
    end; payment_options
  end

  def self.find(id)
    response = Faraday.get("#{Rails.configuration.external_apis['payment_options_api']}/payment_options/#{id}")
    return unless response.success?

    d = JSON.parse(response.body)
    PaymentOption.new(name: d['name'], payment_type: d['payment_type'], max_parcels: d['max_parcels'],
                      tax_percentage: d['tax_percentage'], tax_maximum: d['tax_maximum'],
                      single_parcel_discount: d['single_parcel_discount'], payment_method_id: d['payment_method_id'])
  end

  def formatted_payment_type_and_name
    "#{payment_type} - #{name}"
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Layout/LineLength
