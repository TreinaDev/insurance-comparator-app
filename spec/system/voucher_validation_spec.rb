require 'rails_helper'

describe 'Cliente insere um cupom de desconto' do
  it 'e o cupom é valido' do

    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Realizar Pagamento'

    expect(current_path).to eq  
    expect(page).to have_content 'Cupom inserido com sucesso'
    expect(page).to have_content 'Valor Final --- valor com desconto'
  end

  it 'e o cupom é inválido' do

    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Realizar Pagamento'

    expect(current_path).to eq 
    expect(page).to have_content 'Cupom inválido'
    expect(page).to have_content 'Valor Final --- valor sem desconto'
  end

  it 'e o cupom esta expirado' do

    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Realizar Pagamento'

    expect(current_path).to eq  
    expect(page).to have_content 'Cupom expirado'
    expect(page).to have_content 'Valor Final --- valor sem desconto'
  end
end
