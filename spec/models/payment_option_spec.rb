require 'rails_helper'

describe PaymentOption do
  context '.all' do
    it 'retorna os metodos de pagamento disponíveis pela seguradora' do
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/insurance_companies/1/payment_options').and_return(fake_response)
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
      fake_response = double('faraday_response', success?: false, body: '{}')
      allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/insurance_companies/1/payment_options').and_return(fake_response)

      result = PaymentOption.all

      expect(result).to eq []
    end
  end
end
