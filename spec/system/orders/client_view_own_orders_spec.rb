require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    visit orders_path

    expect(current_path).to eq new_client_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end
end
