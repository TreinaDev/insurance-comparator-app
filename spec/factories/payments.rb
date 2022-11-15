FactoryBot.define do
  factory :payment do
    client_id { nil }
    equipment_id { nil }
    order_id { nil }
    card_number { 1 }
    card_name { 'MyString' }
    boleto { 1 }
    pix { 'MyString' }
  end
end
