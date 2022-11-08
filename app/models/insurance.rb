class Insurance
  attr_accessor :id, :insurance_name, :product_model, :packages, :price

  def initialize(id:, insurance_name:, product_model:, packages:, price:)
    @id = id
    @insurance_name = insurance_name
    @product_model = product_model
    @packages = packages
    @price = price
  end

  def self.search(_query)
    insurances = []
    response = Faraday.get("http://localhost:4000/api/v1/insurance/#{@query}")
    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |d|
        insurances << Insurance.new(id: d['id'], insurance_name: d['insurance_name'], product_model: d['product_model'],
                                    packages: d['packages'], price: d['price'])
      end
    end
    insurances
  end

  # def self.find(isurance)
  #   @id = insurance
  #   response = Faraday.get("http://localhost:4000/api/v1/insurance/#{@id}")
  #   if response.status == 200
  #     @insurance = JSON.parse(response.body)
  #   else
  #     redirect_to search_path, notice: 'Não foi possível carregar as informações do pacote'
  #   end
  # end
  
end
