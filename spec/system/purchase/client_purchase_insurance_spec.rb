require 'rails_helper'

describe 'Cliente compra pacote de seguro' do
  it 'a partir da página inicial' do
    client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                            address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                            birth_date: '29/10/1997')
    dados_fake = []
    dados_fake << Insurance.new(id: 1, insurance_name: 'Seguradora 1', product_model: 'iPhone 11', packages: 'Premium',
                                price: 50)
    allow(Insurance).to receive(:search).with('iPhone 11').and_return(dados_fake)

    json_data = Rails.root.join('spec/support/json/insurance.json').read
    fake_response = double('faraday_response', success?: true, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/insurance/1').and_return(fake_response)

    visit root_path
    fill_in 'Produto',	with: 'iPhone 11'
    click_on 'Buscar'
    click_on 'Seguradora 1'
    click_on 'Contratar Seguro'
    within('body') do
      select 'iPhone 12', from: 'Selecione o dispositivo'
      select '12 meses', from: 'Período de contratação'
      click_on 'Finalizar'
    end

    expect(page).to have_content 'Contratação efetuada com sucesso'
    expect(page).to have_content 'Dados do seguro'
    expect(page).to have_content 'Nome da Seguradora: Seguradora 1'
    expect(page).to have_content 'Tipo de Pacote: Premium'
    expect(page).to have_content 'Modelo do Produto: iPhone 11'
    expect(page).to have_content 'Valor de Contratação para 12 meses: R$ 50,00'
  end
end