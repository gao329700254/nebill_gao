FactoryBot.define do
  factory :default_expense_item do
    name { "MyString" }
    display_name { "MyString" }
    standard_amount { 1 }
    is_routing { false }
    is_quantity { false }
    note { "MyString" }
  end

end
