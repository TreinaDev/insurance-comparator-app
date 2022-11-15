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

    order = Order.create!(client: ana, equipment: iphone, status: :insurance_approved)

    json_data = Rails.root.join('spec/support/json/cpfs.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('https://mocki.io/v1/ba1a1ec8-8d1d-47a3-aaf3-4ac9fe9c390c').and_return(fake_response)

    order.validate_cpf(order)

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

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '72341971091',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')

    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                               invoice: fixture_file_upload('spec/support/invoice.png'),
                               photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])

    order = Order.create!(client: ana, equipment: iphone, status: :insurance_approved)

    json_data = Rails.root.join('spec/support/json/cpfs.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('https://mocki.io/v1/ba1a1ec8-8d1d-47a3-aaf3-4ac9fe9c390c').and_return(fake_response)

    order.validate_cpf(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content 'Meus Pedidos'
    expect(page).to have_css 'table', text: 'Dispositivo'
    expect(page).to have_css 'table', text: 'Iphone 14 - ProMax'
    expect(page).to have_css 'table', text: 'Marca'
    expect(page).to have_css 'table', text: 'Apple'
    expect(page).to have_css 'table', text: 'Status da Compra'
    expect(page).to have_css 'table', text: 'CPF Recusado'
  end
end
