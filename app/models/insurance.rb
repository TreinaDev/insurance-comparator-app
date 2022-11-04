class Insurance
  attr_accessor :id, :insurance_name, :product_model, :packages, :price

  def initialize(id:, insurance_name:, product_model:, packages:, price:)
    @id = id
    @insurance_name = insurance_name
    @product_model = product_model
    @packages = packages
    @price = price
  end

  def self.search
    @query = params[:query]
    insurances = []
    # conecto na API e pego as informações dela
    response = Faraday.get("http://localhost:4000/api/v1/insurance/#{@query}")
    if response.status == 200
      # converto em formato JSON
      data = JSON.parse(response.body)
      # percorro o array - cada item do array vai ser um hash - tiro as informações do hash e monto o objeto
      data.each do |d|
        insurances << Insurance.new(id: d['id'], insurance_name: d['insurance_name'], product_model: d['product_model'],
                                    packages: d['packages'], price: d['price'])
      end
    end
    insurances
  end
end
