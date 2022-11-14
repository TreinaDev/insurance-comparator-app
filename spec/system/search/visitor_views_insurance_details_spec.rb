require 'rails_helper'

describe 'visitante vê detalhes do pacote' do
  it 'com sucesso' do
    insurance = {"id"=>1, "insurance_name"=>"Seguradora 1", "product_model"=>"iPhone 11", "packages"=>"Premium", "price"=>50}
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit insurance_path(insurance['id'])

    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
    expect(page).not_to have_content 'Nome da Seguradora: Seguradora 2'
    expect(page).not_to have_content 'Tipo de Pacote: Plus'
    expect(page).not_to have_content 'Valor de Contratação para 12 meses: R$ 20,00'
  end
  it 'e não consegue visualizar o pacote' do
    insurance_a = {"id"=>1, "insurance_name"=>"Seguradora 1", "product_model"=>"iPhone 11", "packages"=>"Premium", "price"=>50}

    insurance = nil
    allow(Insurance).to receive(:find).with('1').and_return(insurance)

    visit insurance_path(insurance_a['id'])

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar as informações do pacote'
  end
end