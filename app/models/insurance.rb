class Insurance
  # belongs_to :order
  attr_accessor :id, :name, :max_period, :min_period, :insurance_company_id, :insurance_name, :price, 
                :product_category_id, :product_category, :product_model

  def initialize(id:, name:, max_period:, min_period:, insurance_company_id:,
                 insurance_name:, price:, product_category_id:, product_category:, product_model:)

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
  end

 def self.search(query)
    insurances = []
    formated_query = query.split.join.downcase
    response = Faraday.get("https://636fa128bb9cf402c81beec1.mockapi.io/api/v1/insurances")
    # response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/insurances/#{query}")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        if d['product_model'].split.join.downcase == formated_query
          insurances << Insurance.new(id: d['id'], name: d['name'], max_period: d['max_period'], min_period: d['min_period'], 
          insurance_company_id: d['insurance_company_id'], insurance_name: d['insurance_name'], price: d['price'],
          product_category_id: d['product_category_id'], product_category: d['product_category'], 
          product_model: d['product_model'])
        end
      end
    end
    insurances
  end

  def self.find(id)
    response = Faraday.get("https://636fa128bb9cf402c81beec1.mockapi.io/api/v1/insurances/#{id}")
    # response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/insurances/#{id}")
    if response.success?
      d = JSON.parse(response.body)
      insurance = Insurance.new(id: d['id'], name: d['name'], max_period: d['max_period'], min_period: d['min_period'],
      insurance_company_id: d['insurance_company_id'], insurance_name: d['insurance_name'], price: d['price'],
      product_category_id: d['product_category_id'], product_category: d['product_category'],
      product_model: d['product_model'])
    end; insurance
  end
end
