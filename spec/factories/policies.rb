FactoryBot.define do
  factory :policy do
    code { 'MyString' }
    expiration_date { '2022-11-15' }
    status { 1 }
    client_name { 'MyString' }
    client_registration_number { 1 }
    client_email { 'MyString' }
    equipment_id { 1 }
    purchase_date { '2022-11-15' }
    policy_period { 1 }
    package_id { 1 }
    order_id { 1 }
    insurance_company_id { 1 }
  end
end
