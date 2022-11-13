# require 'rails_helper'

RSpec.describe Order, type: :model do
  context '.validate_cpf' do
    it 'e retorna CPF válido' do
      user = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                     address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                     birth_date: '29/10/1997')

      iphone = Equipment.create!(client: user, name: 'Iphone 14 - ProMax', brand: 'Apple',
                        purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                        photos: [fixture_file_upload('spec/support/photo_1.png'),
                                 fixture_file_upload('spec/support/photo_2.jpg')])

      @order = Order.new(client_id: user, product_id: iphone, status: :insurance_approved)

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
