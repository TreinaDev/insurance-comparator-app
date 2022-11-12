require 'rails_helper'

describe 'Usuário tem seu CPF consultado na aplicação Anti-Fraude' do
  it 'e CPF é válido' do
  end

  it 'e o CPF está bloqueado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')
                         
    iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                               invoice: fixture_file_upload('spec/support/invoice.png'),
                               photos: [fixture_file_upload('spec/support/photo_1.png'),
                               fixture_file_upload('spec/support/photo_2.jpg')])

    insurances = []
    insurances << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)

    insurances << Insurance.new(id: 2, insurance_name: 'Seguradora 2', product_model: 'iPhone 11', packages: 'Plus',
                                price: 20)

    allow(Insurance).to receive(:search).with('iPhone 11').and_return(insurances)

    insurance = Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                              price: 50)

    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit root_path
    fill_in 'Produto', with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'
    click_on 'Contratar Seguro'

    expect(page).to have_content 'Status da Compra: CPF bloqueado'
  end
end
