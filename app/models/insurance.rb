# rubocop:disable Metrics/ParameterLists
# rubocop:disable Layout/MethodLength

class Insurance
  attr_accessor :id, :name, :max_period, :min_period, :insurance_company_id, :insurance_name,
                :price_per_month, :product_category_id, :product_model, :product_model_id,
                :coverages, :services

  def initialize(id:, name:, max_period:, min_period:, insurance_company_id:, insurance_name:,
                 price_per_month:, product_category_id:, product_model:, product_model_id:, coverages:, services:)

    @id = id
    @name = name
    @max_period = max_period
    @min_period = min_period
    @insurance_company_id = insurance_company_id
    @insurance_name = insurance_name
    @product_category_id = product_category_id
    @product_model = product_model
    @product_model_id = product_model_id
    @coverages = coverages
    @services = services
    @price_per_month = price_per_month
  end

  # rubocop:disable Metrics/AbcSize
  def self.find(product_id, id)
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']
                            }/products/#{product_id}/packages/#{id}")
    if response.success?
      d = JSON.parse(response.body)
      insurance = Insurance.new(id: d['id'].to_i, name: d['name'], max_period: d['max_period'],
                                min_period: d['min_period'], insurance_company_id: d['insurance_company_id'].to_i,
                                insurance_name: d['insurance_company_name'],
                                price_per_month: d['price_per_month'], product_model: d['product_model'],
                                product_category_id: d['product_category_id'].to_i,
                                product_model_id: d['product_model_id'].to_i,
                                coverages: [{ name: 'Nome', description: 'descrição', code: 'código' }],
                                services: [{ name: 'Nome', description: 'descrição', code: 'código' }])
    end
    insurance
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Layout/MethodLength
