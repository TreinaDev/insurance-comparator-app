require 'rails_helper'

# describe 'Payment_Details API' do
#   context 'GET /api/v1/payment_details/1' do

#     ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '41383204829',
#                          address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
#                          birth_date: '29/10/1997')

#     iphone = Equipment.create!(client: ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
#                                invoice: fixture_file_upload('spec/support/invoice.png'),
#                                photos: [fixture_file_upload('spec/support/photo_1.png'),
#                                         fixture_file_upload('spec/support/photo_2.jpg')])

#     order = Order.create!(client: ana, equipment: iphone, status: :cpf_approved)

#     #payment_data = PaymentDetails.create!(insurance_company_id: 1, packages: 'Premium', payment_method: 'cartão de crédito', cpf: '32165498712', equipment_id: 1)
    
#     get "/api/v1/payment_details/#{payment_data.id}"

#     expect(response.status).to eq 200
#     expect(response.content_type).to include 'application/json'
#     json_response = JSON.parse(response.body)	
#     expect(json_response["cpf"]).to eq '321.654.987-12'
#     expect(json_response.keys).not_to include 'created_at'
#     expect(json_response.keys).not_to include 'updated_at'
#   end
# end