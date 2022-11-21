require 'rails_helper'

describe 'Cliente insere um cupom de desconto' do
  it 'e o cupom é valido' do
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
