json.array!(@partners) do |partner|
  json.extract! partner, :id, :name, :email, :company_name, :created_at, :updated_at
  if @project
    member = partner.members.find_by(project_id: @project.id)
    json.member do
      json.unit_price     member.unit_price
      json.min_limit_time member.min_limit_time
      json.max_limit_time member.max_limit_time
    end
  end
end
