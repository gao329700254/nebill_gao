json.array!(@partners) do |partner|
  json.extract! partner, :id, :cd, :name, :email, :created_at, :updated_at
  json.client { json.extract!(partner.client, :id, :company_name, :zip_code, :phone_number) if partner.client.present? }
  if @project
    member = partner.members.find_by(project_id: @project.id)
    json.member do
      json.unit_price     member.unit_price
      json.working_rate   member.working_rate
      json.min_limit_time member.min_limit_time
      json.max_limit_time member.max_limit_time
    end
  end
end
