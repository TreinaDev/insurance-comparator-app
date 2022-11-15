require 'rails_helper'

describe 'Usuário com CPF aprovado procede com a compra' do
  it 'e tem seus dados enviados para cobrança' do 
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '41383204829',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')

    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                              invoice: fixture_file_upload('spec/support/invoice.png'),
                              photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])

    order = Order.create!(client: ana, equipment: iphone, status: :cpf_approved)

    order.validade_charge(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_css 'table', text: 'Dispositivo'
    expect(page).to have_css 'table', text: 'Iphone 14 - ProMax'
    expect(page).to have_css 'table', text: 'Marca'
    expect(page).to have_css 'table', text: 'Apple'
    expect(page).to have_css 'table', text: 'Status da Compra'
    expect(page).to have_css 'table', text: 'Pagamento em Processamento'
  end
end 