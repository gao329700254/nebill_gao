begin
  require 'slim_lint/rake_task'

  SlimLint::RakeTask.new do |t|
    t.config = '.slim_lint.yml'
    t.files = %w(app/views/**/*.slim)
    t.quiet = false
  end
rescue LoadError
end
