json.array! @projects do |project|
  json.id            project.id
  json.cd            project.cd
  json.name          project.name
end