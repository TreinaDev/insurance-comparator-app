require 'rails_helper'

describe Insurance do
  context '.search' do
    it 'retorna as seguradoras encontradas' do
      api_url = Rails.configuration.external_apis['insurance_api'].to_s
      json_data = Rails.root.join('spec/support/json/insurances.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with("#{api_url}/insurances/iphone11").and_return(fake_response)

      result = Insurance.search('iphone11')

      expect(result.length).to eq 2
      expect(result[0].id).to eq 1
      expect(result[0].insurance_name).to eq 'Seguradora 1'
      expect(result[0].name).to eq 'Super Econômico'
      expect(result[0].price).to eq 100
      expect(result[1].id).to eq 2
      expect(result[1].insurance_name).to eq 'Seguradora 2'
      expect(result[1].name).to eq 'Premium'
      expect(result[1].price).to eq 400
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      api_url = Rails.configuration.external_apis['insurance_api'].to_s
      fake_response = double('faraday_response', success?: false, body: "{'error': 'Erro ao obter dados da pesquisa'}")
      allow(Faraday).to receive(:get).with("#{api_url}/insurances/iphone11").and_return(fake_response)

      result = Insurance.search('iphone11')

      expect(result).to eq []
    end
  end

  context '.find' do
    it 'retorna a seguradora escolhida' do
      api_url = Rails.configuration.external_apis['insurance_api']
      json_data = Rails.root.join('spec/support/json/insurance.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with("#{api_url}/insurances/1").and_return(fake_response)

      result = Insurance.find(1)

      expect(result.id).to eq 1
      expect(result.insurance_name).to eq 'Seguradora 1'
      expect(result.product_model).to eq 'iPhone 11'
      expect(result.name).to eq 'Super Econômico'
      expect(result.price).to eq 100
      expect(result.product_category).to eq 'Telefone'
      expect(result.price).to eq 100
      expect(result.max_period).to eq 18
      expect(result.min_period).to eq 6
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      api_url = Rails.configuration.external_apis['insurance_api']
      fake_response = double('faraday_response', success?: false, body: "{'error': 'Erro ao obter dados da pesquisa'}")
      allow(Faraday).to receive(:get).with("#{api_url}/insurances/1").and_return(fake_response)

      result = Insurance.find(1)

      expect(result).to eq nil
    end
  end
end
