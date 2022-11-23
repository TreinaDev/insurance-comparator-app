require 'rails_helper'

describe 'Cliente insere um cupom de desconto' do
  it 'e o cupom é valido' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                          insurance_model: 'iPhone 11', status:, voucher_name: nil, voucher: nil)

    order_result = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                                 price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                                 insurance_model: 'iPhone 11', status:, voucher_name: 'ABC123', voucher: 20)

    allow(payment).to receive(:voucher_validation).and_return(order_result)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(@order)
    expect(page).to have_content 'Cupom inserido com sucesso'
    expect(page).to have_content 'Valor Final --- valor com desconto'
  end

  it 'e o cupom é inválido' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium', insurance_model: 'iPhone 11', status:, voucher_name: nil, voucher: nil)

    allow(payment).to receive(:voucher_validation).and_return(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(@order)
    expect(page).to have_content 'Cupom inválido'
    expect(page).to have_content 'Valor Final --- valor sem desconto'
  end

  it 'e o cupom está expirado' do
    ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP', birth_date: '29/10/1997')

    order = Order.create!(client: ana, equipment:, payment_method:, contract_period: 10, insurance_id: 45,
                          price_percentage: 5, insurance_name: 'Seguradora 45', packages: 'Premium',
                          insurance_model: 'iPhone 11', status:, voucher_name: nil, voucher: nil)

    allow(payment).to receive(:voucher_validation).and_return(order)

    login_as(ana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'iPhone 11'
    click_on 'Pagar'
    fill_in 'Insira seu Cupom',	with: 'ABC123'
    click_on 'Validar'

    expect(current_path).to eq new_order_payment_path(@order)
    expect(page).to have_content 'Cupom expirado'
    expect(page).to have_content 'Valor Final --- valor sem desconto'
  end
end
