class Product
  attr_accessor :id, :product_model, :brand, :product_category_id, :image_url

  def initialize(id:, product_model:, brand:, product_category_id:, image_url:)

    @id = id
    @product_model = product_model
    @brand = brand
    @product_category_id = product_category_id
    @image_url = image_url
  end

  def self.search(query)
    products = []
    formated_query = query.split.join.downcase
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        next unless d['product_model'].split.join.downcase == formated_query

        products << Product.new(id: d['id'], product_model: d['product_model'],
                                brand:d['brand'], product_category_id: d['product_category_id'],
                                image_url: d['image_url'])
      end
    end
    products
  end

  def self.all
    products = []
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/products")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        products << Product.new(id: d['id'], product_model: d['product_model'],
                                brand:d['brand'], product_category_id: d['product_category_id'],
                                image_url: d['image_url'])
      end
    end
    products
  end
end
