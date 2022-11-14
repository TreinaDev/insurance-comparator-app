require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  # it 'e CPF é válido' do
  # end

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')

    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                               invoice: fixture_file_upload('spec/support/invoice.png'),
                               photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])

    Order.create!(client: ana, equipment: iphone, status: :cpf_disapproved)

    json_data = Rails.root.join('spec/support/json/cpfs.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:5000/api/v1/cpf_list').and_return(fake_response)

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
