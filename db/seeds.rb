# Client (pt-BR: Cliente)
client1 = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                         address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                         birth_date: '29/10/1997')

client2 = Client.create!(name: 'Jessica Leal', email: 'jleal@gmail.com', password: 'meuseguro', cpf: '07424101960',
                         address: 'Rua das Flores, 180', city: 'Curitiba', state: 'PR',
                         birth_date: '14/01/1992')

# Equipment (pt-BR: Dispositivo)
equipment1 = Equipment.new(client: client1, name: 'iPhone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
                           equipment_price: 10_199, product_category_id: 1)
equipment1.invoice.attach(io: Rails.root.join('spec/support/invoice.png').open, filename: 'nota_fiscal.png')
equipment1.photos.attach(io: Rails.root.join('spec/support/photo_1.png').open, filename: 'foto_frente.png')
equipment1.photos.attach(io: Rails.root.join('spec/support/photo_2.jpg').open, filename: 'foto_verso.jpg')
equipment1.save!

equipment2 = Equipment.new(client: client2, name: 'MacBook Air', brand: 'Apple', purchase_date: '13/04/2021',
                           equipment_price: 15_129, product_category_id: 2)
equipment2.invoice.attach(io: Rails.root.join('spec/support/nota_mcbook.png').open, filename: 'nota_fiscal.png')
equipment2.photos.attach(io: Rails.root.join('spec/support/mac_frente.jpg').open, filename: 'foto_da_frente.png')
equipment2.photos.attach(io: Rails.root.join('spec/support/mac_verso.jpg').open, filename: 'foto_do_verso.jpg')
equipment2.save!

equipment3 = Equipment.new(client: client2, name: 'Samsung J7', brand: 'Samsung', equipment_price: 10_199,
                           purchase_date: '01/11/2022', product_category_id: 1)
equipment3.invoice.attach(io: Rails.root.join('spec/support/invoice.png').open, filename: 'nota_fiscal.png')
equipment3.photos.attach(io: Rails.root.join('spec/support/photo_1.png').open, filename: 'foto_frente.png')
equipment3.photos.attach(io: Rails.root.join('spec/support/photo_2.jpg').open, filename: 'foto_verso.jpg')
equipment3.save!

# Insurance (pt-BR: Pacote de Seguro)
insurance1 = Insurance.new(id: 45, name: 'Premium', max_period: 24, min_period: 6,
                           insurance_company_id: 1, insurance_name: 'Seguradora 45', price_per_month: 10.00,
                           product_category_id: 1, product_model: 'iPhone 14',
                           coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
              por danificação da tela do aparelho.' }], services: [], product_model_id: 20)

insurance2 = Insurance.new(id: 46, name: 'Master', max_period: 24, min_period: 6,
                           insurance_company_id: 1, insurance_name: 'Seguradora 46', price_per_month: 10.00,
                           product_category_id: 1, product_model: 'MacBook',
                           coverages: [{ code: '76R', name: 'Quebra de tela', description: 'Assistência
              por danificação da tela do aparelho.' }], services: [], product_model_id: 20)

# Order (pt-BR: Pedido)
Order.create!(client: client1, equipment: equipment1, contract_period: 10, insurance_company_id: 45,
              price: 10.00, final_price: 100, insurance_name: 'Seguradora 45',
              insurance_description: insurance1.to_json,
              package_name: 'Premium', product_category_id: 1, product_category: 'iPhone 14',
              status: :pending)

Order.create!(client: client2, equipment: equipment2, contract_period: 10, insurance_company_id: 46,
              price: 10.00, final_price: 5000, insurance_name: 'Seguradora 46',
              insurance_description: insurance2.to_json,
              package_name: 'Premium', product_category_id: 2, product_category: 'Macbook',
              status: :insurance_company_approval)
