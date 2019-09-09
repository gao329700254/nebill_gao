json.array! @project_files do |project_file|
  json.extract! project_file, :id, :original_filename, :file_type_text
  json.id                 project_file.id
  json.original_filename  project_file.original_filename
  json.size               number_to_human_size(project_file.file.size, locale: :en, precision: 1, strip_insignidicant_zeros: false)
  json.created_at         project_file.created_at
  json.updated_at         project_file.updated_at
  json.file_type          project_file.file_type_text
  json.group do |json|
    json.id   project_file.group&.id
    json.name project_file.group&.name
  end
end
