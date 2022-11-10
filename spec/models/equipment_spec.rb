require 'rails_helper'

RSpec.describe Equipment, type: :model do
  describe '#valid?' do
    it 'deve ter um nome' do
      client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                              state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
      equipment = Equipment.new(name: '', brand: 'Apple', purchase_date: '01/11/2022', client:,
                                invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                         fixture_file_upload('spec/support/photo_2.jpg')])

      result = equipment.valid?

      expect(result).to eq false
      expect(equipment.errors[:name]).to include 'não pode ficar em branco'
    end

    it 'deve ter uma marca' do
      client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                              state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
      equipment = Equipment.new(name: 'Iphone 14 - ProMax', brand: '', purchase_date: '01/11/2022', client:,
                                invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                         fixture_file_upload('spec/support/photo_2.jpg')])

      result = equipment.valid?

      expect(result).to eq false
      expect(equipment.errors[:brand]).to include 'não pode ficar em branco'
    end

    it 'deve ter uma data' do
      client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                              state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
      equipment = Equipment.new(name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '', client:,
                                invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                         fixture_file_upload('spec/support/photo_2.jpg')])

      result = equipment.valid?

      expect(result).to eq false
      expect(equipment.errors[:purchase_date]).to include 'não pode ficar em branco'
    end

    it 'data de compra não deve ser futura' do
      client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                              state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')

      equipment = Equipment.new(name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: 2.days.from_now,
                                client:,
                                invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                         fixture_file_upload('spec/support/photo_2.jpg')])

      equipment.valid?

      expect(equipment.errors.include?(:purchase_date)).to be true
      expect(equipment.errors[:purchase_date]).to include(' deve ser passada.')
    end

    it 'data de compra deve ser passada ou igual a hoje' do
      client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                              state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com',
                              password: 'password')
      equipment = Equipment.new(client:, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                                invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                         fixture_file_upload('spec/support/photo_2.jpg')])

      equipment.valid?

      expect(equipment.errors.include?(:purchase_date)).to be false
    end
  end
end
