# describe 'Order API' do
#   context 'POST/api/v1/insurance_approved' do
#     it 'com sucesso' do
#       order_params = { name: '', code: '' }
#       post '/api/v1/insurance_approved/', params: order_params

#       expect(response).to have_http_status(201)
#       expect(response.content_type).to include 'application/json'
#       json_response = JSON.parse(response.body)
#       expect(json_response['id']).to eq '1'
#       expect(json_response['status']).to eq 'insurance_approved'
#     end

#     it 'e retorna um erro interno do servidor' do
#       allow(Order).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

#       order_params = { name: '', code: '' }
#       post '/api/v1/insurance_approved/', params: order_params

#       expect(response).to have_http_status(500)
#     end
#   end

#   context 'POST/api/v1/insurance_disapproved' do
#     it 'com sucesso' do
#       order_params = { name: '', code: '' }
#       post '/api/v1/insurance_disapproved/', params: order_params

#       expect(response.status).to eq 201
#       expect(response.content_type).to include 'application/json'
#       json_response = JSON.parse(response.body)
#       expect(json_response['id']).to eq '1'
#       expect(json_response['status']).to eq 'insurance_disapproved'
#     end

#     it 'e retorna um erro interno do servidor' do
#       allow(Order).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

#       order_params = { name: '', code: '' }
#       post '/api/v1/insurance_approved/', params: order_params

#       expect(response).to have_http_status(500)
#     end
#   end
# end
