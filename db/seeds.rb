user_ana = Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '07424101960',
                          address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
                          birth_date: '29/10/1997')

equipament = Equipment.new(client: user_ana, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today)
equipament.invoice.attach(io: Rails.root.join('spec/support/invoice.png').open,
                          filename: 'nota_fiscal.png')
equipament.photos.attach(io: Rails.root.join('spec/support/photo_1.png').open,
                         filename: 'foto_frente.png')
equipament.photos.attach(io: Rails.root.join('spec/support/photo_2.jpg').open,
                         filename: 'foto_verso.jpg')
equipament.save!

Order.create!(client: user_ana, equipment: equipament, status: :insurance_approved)
