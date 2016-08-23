json.array! @project_files do |project_file|
  json.id         project_file.id
  json.url        project_file.file.url
  json.name       project_file.file_identifier
  json.size       number_to_human_size(project_file.file.size, locale: :en, precision: 1, strip_insignidicant_zeros: false)
  json.created_at project_file.created_at
  json.updated_at project_file.updated_at
  json.group do |json|
    json.id   project_file.group&.id
    json.name project_file.group&.name
  end
end
