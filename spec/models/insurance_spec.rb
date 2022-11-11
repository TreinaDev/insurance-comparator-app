require 'rails_helper'

describe Insurance do
  context '.search' do
    it 'retorna as seguradoras encontradas' do
      json_data = Rails.root.join('spec/support/json/insurances.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurances/iphone11').and_return(fake_response)

      result = Insurance.search('iphone11')

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
      fake_response = double('faraday_response', success?: false, body: "{'error': 'Erro ao obter dados da pesquisa'}")
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurances/iphone11').and_return(fake_response)

      result = Insurance.search('iphone11')

      expect(result).to eq []
    end
  end

  context '.find' do
    it 'retorna a seguradora escolhida' do
      json_data = Rails.root.join('spec/support/json/insurance.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurance/1').and_return(fake_response)

      result = Insurance.find(1)

      expect(result['id']).to eq 1
      expect(result['insurance_name']).to eq 'Seguradora 1'
      expect(result['product_model']).to eq 'iPhone 11'
      expect(result['packages']).to eq 'Premium'
      expect(result['price']).to eq 50
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      fake_response = double('faraday_response', success?: false, body: "{'error': 'Erro ao obter dados da pesquisa'}")
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurance/1').and_return(fake_response)

      result = Insurance.find(1)

      expect(result).to eq []
    end
  end
end
