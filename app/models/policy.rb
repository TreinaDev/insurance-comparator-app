class Policy 
  def initialize(id:, code:, status:, order:, insurance:)
    @id = id
    @code = code
    @status = status
    @order = self.order
    @insurance = self.insurance
  end

  def.find_by_id 
    response = Faraday.get("http://localhost:4000/api/v1/equipment/#{@id}/policy")
    
    if response.status == 200
      data = JSON.parse(response.body)
      d = data.first
      policy = Policy.new(id: d['id'], d['code'], d['status'], d['order'], d['insurance'])
    end

    policy
  end
end