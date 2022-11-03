class Insurance
  attr_accessor :id, :insurance_name, :product_model, :packages, :price

  def initialize(id:, insurance_name:, product_model:, packages:, price:)
    @id = id
    @insurance_name = insurance_name
    @product_model = product_model
    @packages = packages
    @price = price
  end

  def self.all
    insurances = []
    insurances << Insurance.new(id: 1, insurance_name: "Seguradora 1", product_model: "Iphone 11", packages: "Premium", price: 50)
    insurances << Insurance.new(id: 2, insurance_name: "Seguradora 2", product_model: "Iphone 11", packages: "Plus", price: 20)
    insurances << Insurance.new(id: 3, insurance_name: "Seguradora 3", product_model: "Iphone 11", packages: "Profissional", price: 35)
    insurances << Insurance.new(id: 4, insurance_name: "Seguradora 2", product_model: "Moto G 20", packages: "Plus", price: 20)
    insurances << Insurance.new(id: 5, insurance_name: "Seguradora 3", product_model: "Moto G 20", packages: "Profissional", price: 35)
    insurances
  end
end
