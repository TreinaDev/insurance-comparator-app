require 'rails_helper'

describe PaymentOption do
  context '.all' do
    it 'retorna os metodos de pagamento disponíveis pela seguradora' do
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

      result = PaymentOption.all

      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Laranja'
      expect(result[0].payment_type).to eq 'Cartão de Crédito'
      expect(result[0].tax_percentage).to eq 5
      expect(result[0].tax_maximum).to eq 100
      expect(result[0].max_parcels).to eq 12
      expect(result[0].single_parcel_discount).to eq 1
      expect(result[1].name).to eq 'Roxinho'
      expect(result[1].payment_type).to eq 'Boleto'
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      fake_response = double('faraday_response', success?: false, body: '{}')
      allow(Faraday).to receive(:get).with(api_url.to_s).and_return(fake_response)

      result = PaymentOption.all

      expect(result).to eq []
    end
  end

  context '.find' do
    it 'retorna o meio de pagamento com o id fornecido' do
      api_url = Rails.configuration.external_apis['payment_options_api'].to_s
      json_data = Rails.root.join('spec/support/json/company_payment_option.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      id = 2
      allow(Faraday).to receive(:get).with("#{api_url}/#{id}").and_return(fake_response)

      result = PaymentOption.find(id)

      expect(result.payment_method_id).to eq 2
      expect(result.name).to eq 'Roxinho'
      expect(result.payment_type).to eq 'Boleto'
      expect(result.tax_maximum).to eq 5
      expect(result.tax_percentage).to eq 1
      expect(result.max_parcels).to eq 1
      expect(result.single_parcel_discount).to eq 1
    end
  end

  describe '#formatted_payment_type_and_name' do
    it 'deve formatar o nome e o tipo do pagamento para exibição' do
      payment_option = PaymentOption.new(name: 'Roxinho', payment_type: 'Boleto', tax_percentage: 1, tax_maximum: 5,
                                         max_parcels: 1, single_parcel_discount: 1,
                                         payment_method_id: 2)
      expect(payment_option.formatted_payment_type_and_name).to eq 'Boleto - Roxinho'
    end
  end
end
