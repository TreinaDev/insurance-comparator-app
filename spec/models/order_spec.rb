# require 'rails_helper'

RSpec.describe Order, type: :model do
  context '.validate_cpf' do
    it 'e retorna CPF válido' do
      # @order = Order.new( )
      json_data = Rails.root.join('spec/support/json/cpfs.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/payment/verifica_cpf').and_return(fake_response)

      result = @order.validate_cpf

      expect(page).to have_content 'Status: CPF Aprovado'
    end

    it 'e retorna CPF bloqueado' do
    end
  end
end
