require 'rails_helper'

RSpec.describe Order, type: :model do
  context '.validate_cpf' do
    it 'e retorna CPF válido' do
      ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                           address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                           birth_date: '29/10/1997')

      iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple',
                                 purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                 photos: [fixture_file_upload('spec/support/photo_1.png'),
                                          fixture_file_upload('spec/support/photo_2.jpg')])

      order = Order.create!(client: ana, equipment: iphone, status: :insurance_approved)

      json_data = Rails.root.join('spec/support/json/cpfs.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/payment/verifica_cpf').and_return(fake_response)

      order.validate_cpf(order)
      result = order.status

      expect(result).to eq 'cpf_approved'
    end

    it 'e retorna CPF bloqueado' do
      ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '07424101960',
                           address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                           birth_date: '29/10/1997')

      iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple',
                                 purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                 photos: [fixture_file_upload('spec/support/photo_1.png'),
                                          fixture_file_upload('spec/support/photo_2.jpg')])

      order = Order.create!(client: ana, equipment: iphone, status: :insurance_approved)

      json_data = Rails.root.join('spec/support/json/cpfs.json').read
      fake_response = double('faraday_response', success?: true, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/payment/verifica_cpf').and_return(fake_response)

      puts order.status
      puts order.client.cpf

      order.validate_cpf(order)

      result = order.status

      puts result

      expect(result).to eq 'cpf_desapproved'
    end
  end
end
