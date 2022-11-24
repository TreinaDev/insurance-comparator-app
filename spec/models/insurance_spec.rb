require 'rails_helper'

describe Insurance do
  context '.find' do
    it 'retorna o pacote escolhido' do
      insurance = Insurance.new(id: 10, name: 'Super Econômico', max_period: 18, min_period: 6,
                                insurance_company_id: 1, insurance_company_name: 'Seguradora 1',
                                price_per_month: 100.00, product_category_id: 1, product_model: 'Samsung Galaxy S20',
                                product_model_id: 1, coverages: 'Furto', services: '12')
      allow(Insurance).to receive(:find).with(10).and_return(insurance)

      result = Insurance.find(10)

      expect(result.id).to eq 10
      expect(result.insurance_company_name).to eq 'Seguradora 1'
      expect(result.product_model).to eq 'Samsung Galaxy S20'
      expect(result.name).to eq 'Super Econômico'
      expect(result.product_category_id).to eq 1
      expect(result.price_per_month).to eq 100
      expect(result.max_period).to eq 18
      expect(result.min_period).to eq 6
    end

    it 'retorna vazio se API está suspensa/indisponível' do
      insurance = nil
      allow(Insurance).to receive(:find).with(10).and_return(insurance)

      result = Insurance.find(10)

      expect(result).to eq nil
    end
  end
end
