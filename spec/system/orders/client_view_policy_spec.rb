require 'rails_helper'

describe 'Cliente vê apólice' do
  it 'e vê todas as apólices' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678',
                            cpf: '21234567890', address: 'Rua Dr Nogueira Martins, 680',
                            city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iPhone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022', product_category_id: 1,
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 13, name: 'Premium', max_period: 24, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 175.00, product_category_id: 1,
                              product_model: 'iphone 11', product_model_id: 1,
                              coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])
    equipment_b = Equipment.create!(client:, name: 'iPhone 14', brand: 'Apple', equipment_price: 1000,
                                    purchase_date: '01/11/2022', product_category_id: 1,
                                    invoice: fixture_file_upload('spec/support/invoice.png'),
                                    photos: [fixture_file_upload('spec/support/photo_1.png'),
                                             fixture_file_upload('spec/support/photo_2.jpg')])
    insurance_b = Insurance.new(id: 14, name: 'Premium', max_period: 24, min_period: 6, insurance_company_id: 1,
                                insurance_name: 'Seguradora 45', price_per_month: 175.00, product_category_id: 1,
                                product_model: 'iphone 11', product_model_id: 1,
                                coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])
    Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                  contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                  package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                  voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                  product_model: 'iPhone 11', status: :charge_approved, policy_id: 1,
                  package_id: insurance.id)
    Order.create!(client:, equipment: equipment_b, min_period: 1, max_period: 24, price: 200.00,
                  contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                  package_name: 'Básico', product_category: 'Celular', product_category_id: 1,
                  voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                  product_model: 'iPhone 14', status: :charge_approved, policy_id: 1,
                  package_id: insurance_b.id)

    login_as(client)
    visit root_path
    click_on 'Ana Lima | ana@gmail.com'
    click_on 'Minhas Apólices'

    expect(page).to have_content 'iPhone 14'
    expect(page).to have_content 'iPhone 11'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 45'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Tipo de Pacote: Básico'
  end
  it 'referente a pedido finalizado' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678',
                            cpf: '21234567890', address: 'Rua Dr Nogueira Martins, 680',
                            city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')
    equipment = Equipment.create!(client:, name: 'iphone 11', brand: 'Apple', equipment_price: 1000,
                                  purchase_date: '01/11/2022', product_category_id: 1,
                                  invoice: fixture_file_upload('spec/support/invoice.png'),
                                  photos: [fixture_file_upload('spec/support/photo_1.png'),
                                           fixture_file_upload('spec/support/photo_2.jpg')])
    insurance = Insurance.new(id: 13, name: 'Premium', max_period: 24, min_period: 6, insurance_company_id: 1,
                              insurance_name: 'Seguradora 45', price_per_month: 175.00, product_category_id: 1,
                              product_model: 'iphone 11', product_model_id: 1,
                              coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
                              por danificação da tela do aparelho.' }], services: [])
    order = Order.create!(client:, equipment:, min_period: 1, max_period: 24, price: 200.00,
                          contract_period: 10, insurance_company_id: 45, insurance_name: 'Seguradora 45',
                          package_name: 'Premium', product_category: 'Celular', product_category_id: 1,
                          voucher_price: 10.00, voucher_code: 'DESCONTO10', final_price: 1990.00,
                          product_model: 'iPhone 11', status: :charge_approved,
                          package_id: insurance.id, policy_id: 1)
    order_id = order.id
    other_json_data = Rails.root.join('spec/support/json/policy.json').read
    fake_response = double('faraday_response', status: 200, body: other_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/policies/order/#{order_id}").and_return(fake_response)

    login_as(client)
    visit order_policy_path(order_id, order.policy_id)

    expect(page).to have_content 'Dados da Apólice'
    expect(page).to have_content 'Nome do Cliente: Maria Alves'
    expect(page).to have_content 'CPF do Cliente: 99950033340'
    expect(page).to have_content 'Código da Apólice: NIUGBWSTJ5'
    expect(page).to have_content 'Status: Ativa'
    expect(page).to have_content 'Data de Contratação: 2022-11-21'
    expect(page).to have_content 'Período Contratado: 12 meses'
    expect(page).to have_content 'Data de Vencimento: 2023-11-21'
    expect(page).to have_content 'Seguradora: Seguradora 45'
    expect(page).to have_content 'Pacote: Premium'
    expect(page).to have_content 'Dispositivo: iphone 11'
  end
end
