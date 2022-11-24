class Product
  attr_accessor :id, :product_model, :brand, :product_category_id, :image_url

  def initialize(id:, product_model:, brand:, product_category_id:, image_url:)
    @id = id
    @product_model = product_model
    @brand = brand
    @product_category_id = product_category_id
    @image_url = image_url
  end

  # rubocop:disable Layout/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.search(query)
    products = []
    formated_query = query.split.join.downcase
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products")
    data = JSON.parse(response.body) if response.success?
    data.each do |d|
      next unless d['product_model'].split.join.downcase == formated_query

      products << Product.new(id: d['id'], product_model: d['product_model'], brand: d['brand'],
                              product_category_id: d['product_category_id'], image_url: d['image_url'])
    end; products
  end

  def self.product_by_category(id)
    product_by_category = []
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/product_categories/#{id}/products")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        product_by_category << Product.new(id: d['id'], product_model: d['product_model'],
                                           brand: d['brand'], product_category_id: d['product_category_id'],
                                           image_url: d['image_url'])
      end
    end
    product_by_category
  end
end
# rubocop:enable Layout/MethodLength
# rubocop:enable Metrics/AbcSize
