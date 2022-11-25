require 'rails_helper'

describe 'Usuário edita um dispositivo' do
  it 'se estiver autenticado' do
    client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                            state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client:, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    patch(equipment_path(equipment), params: {equipment: {equipment_price: 15_199}})
    expect(response).to redirect_to new_client_session_path
  end

  it 'se o dispositivo não estiver vinculado a um pedido' do
    client = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru',
                            state: 'SP', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    equipment = Equipment.create!(client:, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: '01/11/2022',
                                  invoice: fixture_file_upload('spec/support/invoice.png'), equipment_price: 10_199,
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 67, name: 'Super Econômico', max_period: 18, min_period: 6, insurance_company_id: 45,
                              insurance_name: 'Seguradora 45', price: 100.00, product_category_id: 1,
                              product_category: 'Telefone', product_model: 'iPhone 11')
    Order.create!(status: :insurance_approved, contract_period: 9, equipment:,
                  client:, insurance_name: insurance.insurance_name, package_name: insurance.name,
                  product_model: insurance.product_category, price: insurance.price,
                  insurance_company_id: insurance.insurance_company_id)

    login_as client

    patch(equipment_path(equipment), params: {equipment: {equipment_price: 15_199}})
    expect(response).to redirect_to root_path
  end
end