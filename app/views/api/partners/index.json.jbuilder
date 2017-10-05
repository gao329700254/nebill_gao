json.array!(@partners) do |partner|
  json.extract! partner, :id, :cd, :name, :email, :company_name, :address, :zip_code, :phone_number, :created_at, :updated_at
  if @bill
    member = partner.members.find_by(bill_id: @bill.id)
    json.member do
      json.unit_price     member.unit_price
      json.working_rate   member.working_rate
      json.min_limit_time member.min_limit_time
      json.max_limit_time member.max_limit_time
    end
  end
end
