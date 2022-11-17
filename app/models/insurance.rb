# rubocop:disable Metrics/ParameterLists

class Insurance
  extend ActiveModel::Translation
  attr_accessor :id, :insurance_name, :product_model, :packages, :price

  def initialize(id:, insurance_company_id:, insurance_name:, product_model:, packages:, price:)
    @id = id
    @insurance_company_id = insurance_company_id
    @insurance_name = insurance_name
    @product_model = product_model
    @packages = packages
    @price = price
  end

  def self.search(query)
    insurances = []
    response = Faraday.get("http://localhost:4000/api/v1/insurances/#{query}")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |d|
        insurances << Insurance.new(id: d['id'], insurance_company_id: d['insurance_company_id'],
                                    insurance_name: d['insurance_name'], product_model: d['product_model'],
                                    packages: d['packages'], price: d['price'])
      end
    end; insurances
  end

  def self.find(id)
    response = Faraday.get("https://636ea488bb9cf402c806e80f.mockapi.io/api/v1/insurances/#{id}")
    if response.success?
      d = JSON.parse(response.body)
      insurance = Insurance.new(id: d['id'], insurance_company_id: d['insurance_company_id'],
                                insurance_name: d['insurance_name'], product_model: d['product_model'],
                                packages: d['packages'], price: d['price'])
    end; insurance
  end
end

# rubocop:enable Metrics/ParameterLists
