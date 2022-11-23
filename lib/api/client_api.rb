class ClientApi
  def initialize(client)
    @name = client.name
    @email = client.email
    @cpf = client.cpf
    @address = client.address
    @city = client.city
    @state = client.state
    @birth_date = client.birth_date
  end
end
