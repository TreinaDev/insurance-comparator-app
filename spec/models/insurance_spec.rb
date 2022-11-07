require 'rails_helper'

describe Insurance do
  context '.search' do
    it 'retorna as seguradoras encontradas' do
      json_data = Rails.root.join('spec/support/json/insurances.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@query}").and_return(fake_response)

      result = Insurance.search(@query)

      expect(result.length).to eq 2
      expect(result[0].id).to eq 1
      expect(result[0].insurance_name).to eq 'Seguradora 1'
      expect(result[0].product_model).to eq 'iPhone 11'
      expect(result[0].packages).to eq 'Premium'
      expect(result[0].price).to eq 50
      expect(result[1].id).to eq 2
      expect(result[1].insurance_name).to eq 'Seguradora 2'
      expect(result[1].product_model).to eq 'iPhone 11'
      expect(result[1].packages).to eq 'Plus'
      expect(result[1].price).to eq 20
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      fake_response = double('faraday_response', status: 500, body: "{'error': 'Erro ao obter dados da pesquisa'}")
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/insurance/#{@query}").and_return(fake_response)

      result = Insurance.search(@query)

      expect(result).to eq []
    end
  end
end
