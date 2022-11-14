Client.create!(name: 'Ana Lima', email: 'ana@gmail.com', password: '12345678', cpf: '21234567890',
               address: 'Rua Dr Nogueira Martins, 680', city: 'São Paulo', state: 'SP',
               birth_date: '29/10/1997')

# Equipment.new(client_id: 1, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today,
#               invoice: fixture_file_upload('spec/support/invoice.png'),
#               photos: [fixture_file_upload('spec/support/photo_1.png'),
#                        fixture_file_upload('spec/support/photo_2.jpg')])

Equipment.create(client_id: 1, name: 'Iphone 14 - ProMax', brand: 'Apple', purchase_date: Time.zone.today)
Equipment.create(client_id: 1, name: 'TV LG', brand: 'LG', purchase_date: Time.zone.today)
Equipment.create(client_id: 1, name: 'Playstation 5', brand: 'Sony', purchase_date: Time.zone.today)
