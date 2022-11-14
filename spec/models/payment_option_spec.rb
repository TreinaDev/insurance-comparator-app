require 'rails_helper'

describe PaymentOption do
  context '.all' do
    it 'retorna os metodos de pagamento disponíveis pela seguradora' do
      json_data = Rails.root.join('spec/support/json/company_payment_options.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('https://mocki.io/v1/f914b988-2ce9-4263-bca2-dd40fd3a20ba').and_return(fake_response)

      result = PaymentOption.all

      expect(result.length).to eq 3
      expect(result[1].payment_method_id).to eq 3
      expect(result[1].payment_method_name).to eq 'Pix'
      expect(result[1].max_installments).to eq 1
      expect(result[1].single_installment_discount).to eq 20
      expect(result[1].payment_method_status).to eq 0
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      fake_response = double('faraday_response', success?: false, body: '{}')
      allow(Faraday).to receive(:get).with('https://mocki.io/v1/f914b988-2ce9-4263-bca2-dd40fd3a20ba').and_return(fake_response)

      result = PaymentOption.all

      expect(result).to eq []
    end
  end
end
