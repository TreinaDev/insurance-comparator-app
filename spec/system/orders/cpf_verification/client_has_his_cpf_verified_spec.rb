require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  it 'e CPF é válido' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '41383204829',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                               invoice: fixture_file_upload('spec/support/invoice.png'),
                               photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])
    order = Order.create!(client: ana, equipment: iphone, status: :pending)

    order_result = Order.create!(client: ana, equipment: iphone, status: :charge_pending)
    allow(order).to receive(:validate_cpf).with('41383204829').and_return(order_result)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_content 'Iphone 14 - ProMax'
    expect(page).to have_content 'Apple'
    expect(page).to have_content 'Pagamento em Processamento'
  end

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '72341971091',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                               invoice: fixture_file_upload('spec/support/invoice.png'),
                               photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])
    order = Order.create!(client: ana, equipment: iphone, status: :pending)

    order_result = Order.create!(client: ana, equipment: iphone, status: :cpf_disapproved)
    allow(order).to receive(:validate_cpf).with('72341971091').and_return(order_result)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_content 'Iphone 14 - ProMax'
    expect(page).to have_content 'Apple'
    expect(page).to have_content 'CPF Recusado'
  end
end
