begin
  require 'scss_lint/rake_task'

  SCSSLint::RakeTask.new do |t|
    t.config = '.scss_lint.yml'
    t.files = %w(app/assets/stylesheets)
    t.quiet = false
  end
rescue LoadError
  puts 'scss_lint load error'
end
