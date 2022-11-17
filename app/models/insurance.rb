class Insurance
  extend ActiveModel::Translation
  attr_accessor :id, :insurance_name, :product_model, :packages, :price

  def initialize(id:, insurance_name:, product_model:, packages:, price:)
    @id = id
    @insurance_name = insurance_name
    @product_model = product_model
    @packages = packages
    @price = price
  end

  def self.search(query)
    insurances = []
    response = Faraday.get("#{Rails.configuration.external_apis['insurances_api']}/insurances/#{query}")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        insurances << Insurance.new(id: d['id'], insurance_name: d['insurance_name'], product_model: d['product_model'],
                                    packages: d['packages'], price: d['price'])
      end
    end
    insurances
  end

  def self.find(id)
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/insurances/#{id}")
    if response.success?
      d = JSON.parse(response.body)
      insurance = Insurance.new(id: d['id'], insurance_name: d['insurance_name'], product_model: d['product_model'],
                                packages: d['packages'], price: d['price'])
    end; insurance
  end
end
