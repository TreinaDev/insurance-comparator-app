require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  it 'e CPF é válido' do
  end

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    #preciso de um dispositivo
    #preciso de uma compra

    login_as(ana)
    visit root_path
    click_on 'Meus dispositivos'
    #qual caminho até a tela de compra?

    expect(page).to have_content 'Status da Compra: CPF bloqueado'
  end
end
