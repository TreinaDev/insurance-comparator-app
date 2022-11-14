require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'a partir da página de detalhes do pacote' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create(client_id: 1, name: 'Iphone', brand: 'Apple', purchase_date: Time.zone.today)
    insurance = {"id"=>1, "insurance_name"=>"Seguradora 1", "product_model"=>"iPhone 11", "packages"=>"Premium", "price"=>50}
    payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Roxo', max_installments: 5, tax_percentage: 5,
                                      tax_maximum: 2, payment_method_status: 'aprovado',
                                      single_installment_discount:1)
    payment_method_b = PaymentOption.new(payment_method_id: 2, payment_method_name: 'Azul', max_installments: 1, tax_percentage: 15,
                                      tax_maximum: 7, payment_method_status: 'aprovado',
                                      single_installment_discount:1)
                              
    visit insurance_path(insurance['id'])                            
    click_on 'Contratar'
    
    expect(current_path).to eq new_order_path
    expect(page).to have_content 'Dados do seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
  end
  it 'e preenche os dados' do 
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    equipment = Equipment.create(client_id: 1, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today)
    equipment_b = Equipment.create(client_id: 1, name: 'TV LG', brand: 'LG', purchase_date: Time.zone.today)
    insurance = {"id"=>1, "insurance_name"=>"Seguradora 1", "product_model"=>"iPhone 11", "packages"=>"Premium", "price"=>50}

    payment_method = PaymentOption.new(payment_method_id: 1, payment_method_name: 'Roxo', max_installments: 5, tax_percentage: 5,
                                      tax_maximum: 2, payment_method_status: 'aprovado',
                                      single_installment_discount:1)
    payment_method_b = PaymentOption.new(payment_method_id: 2, payment_method_name: 'Azul', max_installments: 1, tax_percentage: 15,
                                      tax_maximum: 7, payment_method_status: 'aprovado',
                                      single_installment_discount:1)

    allow(PaymentOption).to receive(:all).with(no_args).and_return([payment_method, payment_method_b])
         
    visit insurance_path(insurance['id'])
                                  
    click_on 'Contratar'
    within ('form') do
      select 'Iphone 14 - ProMax', from: 'Selecione o dispositivo'
      select '6', from: 'Período de contratação em meses'
      select 'Roxo', from: 'Selecione o meio de pagamento'
    end
    click_on 'Enviar'
    
    # expect(current_path).to eq new_payment_method_path
    # expect(page).to have_content 'Seu dispositivo está em análise pela seguradora'
  end
end