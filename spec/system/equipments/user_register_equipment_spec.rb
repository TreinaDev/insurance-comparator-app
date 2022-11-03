require 'rails_helper'

describe 'Usuário cadastra dispositivo' do 
  it 'a partir da tela inicial' do 
    #Arrange
    user = Client.create!(name: 'Usuário 1', cpf: '60536252050', address: 'Rua Primavera, 424', city: 'Bauru', birth_date: '12/05/1998', email: 'usuario@email.com', password: 'password')
    
    #Act
    login_as(user)
    visit(root_path)
    click_on 'Usuário 1'
    click_on 'Meus Dispositivos'
    
    #Assert
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Marca'
    expect(page).to have_field 'Data da compra'

  end

end