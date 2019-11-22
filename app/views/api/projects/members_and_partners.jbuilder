json.array!(@members_and_partners) do |member_and_partner|
  json.id                    member_and_partner.id
  json.unit_price            member_and_partner.unit_price
  json.working_rate          member_and_partner.working_rate
  json.min_limit_time        member_and_partner.min_limit_time
  json.max_limit_time        member_and_partner.max_limit_time
  json.working_period_start  member_and_partner.working_period_start
  json.working_period_end    member_and_partner.working_period_end
  json.man_month             member_and_partner.man_month
  json.name                  member_and_partner.employee.name
  json.email                 member_and_partner.employee.email
  json.employee_id           member_and_partner.employee.id
end
