require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'nome não pode ficar em branco' do
        client = Client.new(name: '')
        client.valid?
        expect(client.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'cpf não pode ficar em branco' do
        client = Client.new(cpf: '')
        client.valid?
        expect(client.errors[:cpf]).to include 'não pode ficar em branco'
      end

      it 'email não pode ficar em branco' do
        client = Client.new(email: '')
        client.valid?
        expect(client.errors[:email]).to include 'não pode ficar em branco'
      end

      it 'endereço não pode ficar em branco' do
        client = Client.new(address: '')
        client.valid?
        expect(client.errors[:address]).to include 'não pode ficar em branco'
      end

      it 'cidade não pode ficar em branco' do
        client = Client.new(city: '')
        client.valid?
        expect(client.errors[:city]).to include 'não pode ficar em branco'
      end

      it 'estado não pode ficar em branco' do
        client = Client.new(state: '')
        client.valid?
        expect(client.errors[:state]).to include 'não pode ficar em branco'
      end
    end

    context 'length' do
      it 'estado deve ter 2 caracteres' do
        client = Client.new(state: 'S')
        client.valid?
        expect(client.errors[:state]).to include 'não possui o tamanho esperado (2 caracteres)'
      end

      it 'cpf deve ter 11 caracteres' do
        client = Client.new(cpf: '077')
        client.valid?
        expect(client.errors[:cpf]).to include 'não possui o tamanho esperado (11 caracteres)'
      end
    end

    context 'comparison' do
      it 'data de nascimento deve ser passada' do
        client = Client.new(birth_date: 1.month.from_now)
        client.valid?
        expect(client.errors[:birth_date]).to include "deve ser menor que #{Time.zone.today}"
      end
    end

    context 'numericality' do
      it 'cpf deve ser um número' do
        client = Client.new(cpf: 'cpfabc12345')
        client.valid?
        expect(client.errors[:cpf]).to include 'não é um número'
      end
    end

    context 'uniqueness' do
      it 'cpf deve ser único' do
        Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                       address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                       birth_date: '29/10/1997')
        client = Client.new(cpf: '21234567890')
        client.valid?
        expect(client.errors[:cpf]).to include 'já está em uso'
      end

      it 'email deve ser único' do
        Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                       address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                       birth_date: '29/10/1997')
        client = Client.new(email: 'ana@gmail.com')
        client.valid?
        expect(client.errors[:email]).to include 'já está em uso'
      end
    end
  end

  context 'format' do
    it 'estado deve ser armazenado em maiúsculo' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678',
                              cpf: '21234567890', address: 'Rua Dr Nogueira Martins, 680',
                              city: 'São Paulo', state: 'sp', birth_date: '29/10/1997')
      client.valid?
      expect(client.state).to eq 'SP'
    end

    it 'deve formatar nome e email para exibição' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'sp',
                              birth_date: '29/10/1997')
      expect(client.formatted_name_and_email).to eq 'Ana Lima | ana@gmail.com'
    end

    it 'deve formatar o endereço para exibição' do
      client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                              address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'sp',
                              birth_date: '29/10/1997')
      expect(client.formatted_address).to eq 'Rua Dr Nogueira Martins, 680 | São Paulo - SP'
    end

    it 'nome deve conter somente letras' do
      client = Client.new(name: 1)
      client.valid?
      expect(client.errors[:name]).to include 'não é válido'
    end

    it 'cidade deve conter somente letras' do
      client = Client.new(city: 1)
      client.valid?
      expect(client.errors[:city]).to include 'não é válido'
    end

    it 'estado deve conter somente letras' do
      client = Client.new(state: 2)
      client.valid?
      expect(client.errors[:state]).to include 'não é válido'
    end

    it 'endereço deve conter letras e pode conter números' do
      client = Client.new(address: 2)
      client.valid?
      expect(client.errors[:address]).to include 'não é válido'
    end
  end
end
