require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'a partir da página de detalhes do pacote' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    insurance_package = Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                      price: 50)
  
    equipment = Equipment.create!(client: client, name: 'Iphone 14 - ProMax', brand: 'Apple',
                                purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])
    
    visit new_order_path
  
    within ('form') do
      select 'Iphone 14 - ProMax', from: 'Selecione o dispositivo'
      select '6 meses', from: 'Selecione o período de contratação'
      select 'Cartão', from: 'Selecione o meio de pagamento'
    end
    click_on 'Contratar'
    
    expect(current_path).to eq new_payment_path
    expect(page).to have_content 'Dados do seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: Iphone 14 - ProMax'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
    expect(page).to have_content 'Seu dispositivo está em análise pela seguradora'
  end
  it 'e acessa página de pagamento no cartão' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    insurance_package = Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                      price: 50)
  
    equipment = Equipment.create!(client: client, name: 'Iphone 14 - ProMax', brand: 'Apple',
                                purchase_date: '01/11/2022', invoice: fixture_file_upload('spec/support/invoice.png'),
                                photos: [fixture_file_upload('spec/support/photo_1.png'),
                                        fixture_file_upload('spec/support/photo_2.jpg')])
    
    visit new_payment_path
  
    within ('form') do
      fill_in 'Nome no cartão', with: 'Ana Lima'
      fill_in 'Número do cartão', with: '5274 5763 9425 9961'
      fill_in 'Validade', with: '05/12'
      fill_in 'CVV', with: '123'
    end
    click_on 'Contratar'
    
    expect(current_path).to eq new_payment_path(equipment.id)
    expect(page).to have_content 'Seu pagamento foi enviado com sucesso'
    #redireciona para pagina de dispositivo
  end
end