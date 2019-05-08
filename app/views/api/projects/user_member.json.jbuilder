json.array!(@members) do |member|
  json.id              member.id
  json.unit_price      member.unit_price
  json.working_rate    member.working_rate
  json.min_limit_time  member.min_limit_time
  json.max_limit_time  member.max_limit_time
  json.name            member.employee.name
  json.email           member.employee.email
  json.employee_id     member.employee.id
end
