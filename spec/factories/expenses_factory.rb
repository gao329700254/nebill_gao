FactoryBot.define do
  factory :expense do
    default_id { "" }
    use_date { "2018-08-15" }
    amount { "" }
    depatture_location { "2018-08-15" }
    arrival_location { "2018-08-15" }
    quantity { "" }
    note { "MyString" }
    payment_type { "" }
  end

end
