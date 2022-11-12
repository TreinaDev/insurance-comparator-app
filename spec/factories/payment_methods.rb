FactoryBot.define do
  factory :payment_method do
    card_number { "MyString" }
    card_brand { "MyString" }
    boleto_number { "MyString" }
    pix_code { "MyString" }
    order { nil }
  end
end
