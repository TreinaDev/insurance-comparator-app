# login de clientes
client = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
                        address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                        birth_date: '29/10/1997')

# dispositivos cadastrados 
equipment = Equipment.new(client:, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today)
equipment.invoice.attach(io: Rails.root.join('spec/support/invoice.png').open, filename: 'nota_fiscal.png')
equipment.photos.attach(io: Rails.root.join('spec/support/photo_1.png').open, filename: 'foto_frente.png')
equipment.photos.attach(io: Rails.root.join('spec/support/photo_2.jpg').open, filename: 'foto_verso.jpg')
equipment.save!

equipment2 = Equipment.new(client:, name: 'Macbook Air', brand: 'Apple', purchase_date: 1.month.ago)
equipment2.invoice.attach(io: Rails.root.join('spec/support/nota_mcbook.png').open, filename: 'nota_fiscal.png')
equipment2.photos.attach(io: Rails.root.join('spec/support/mac_frente.jpg').open, filename: 'foto_da_frente.png')
equipment2.photos.attach(io: Rails.root.join('spec/support/mac_verso.jpg').open, filename: 'foto_do_verso.jpg')
equipment2.save!
