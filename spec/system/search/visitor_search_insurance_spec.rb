require 'rails_helper'

describe 'Visitante procura por seguros' do
  it 'na página inicial' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas Vindas Ao Comparador de Seguros'
    expect(page).to have_field 'Busca'
  end  
  
  it 'a partir do nome do seu produto' do

    visit root_path
    fill_in "Busca",	with: "Iphone 11"
    click_on 'Buscar'
    
    expect(current_path).to eq search_path
    expect(page).to have_content ' '  
    expect(page).to have_content ' '  
    expect(page).to have_content ' '
  end
end