# rubocop:disable Metrics/ParameterLists
# rubocop:disable Layout/LineLength

class Insurance
  attr_accessor :id, :name, :max_period, :min_period, :insurance_company_id, :insurance_name, :price,
                :product_category_id, :product_category, :product_model, :product_model_id,
                :coverages, :services

  def initialize(id:, name:, max_period:, min_period:, insurance_company_id:, insurance_name:, price:,
                 product_category_id:, product_category:, product_model:, product_model_id:, coverages:, services:)

    @id = id
    @name = name
    @max_period = max_period
    @min_period = min_period
    @insurance_company_id = insurance_company_id
    @insurance_name = insurance_name
    @price = price
    @product_category_id = product_category_id
    @product_category = product_category
    @product_model = product_model
    @product_model_id = product_model_id
    @coverages = coverages
    @services = services
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength

  # rubocop:enable Metrics/MethodLength

  def self.find(id)
    insurances = []
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/packages")
    if response.success?
      d = JSON.parse(response.body)
      insurances << Insurance.new(id: d['id'], name: d['name'], max_period: d['max_period'], min_period: d['min_period'],
                                  insurance_company_id: d['insurance_company_id'],
                                  insurance_name: d['insurance_name'], price: d['price_per_month'],
                                  product_category_id: d['product_category_id'], product_category: d['product_category'],
                                  product_model: d['product_model'], product_model_id: d['product_model_id'],
                                  coverages: d['coverages'], services: d['services'])
    end
    insurances
  end

  def self.all
    insurances = []
    response = Faraday.get("https://63781a5e5c477765122c38f4.mockapi.io/api/v1/insurances/")
    # response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        insurances << Insurance.new(id: d['id'], name: d['name'], max_period: d['max_period'], min_period: d['min_period'],
                                    insurance_company_id: d['insurance_company_id'],
                                    insurance_name: d['insurance_name'], price: d['price_per_month'],
                                    product_category_id: d['product_category_id'], product_category: d['product_category'],
                                    product_model: d['product_model'], product_model_id: d['product_model_id'],
                                    coverages: d['coverages'], services: d['services'])
      end
    end
    insurances
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Layout/LineLength
