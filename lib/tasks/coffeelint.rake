begin
  require 'coffeelint' unless defined?(Coffeelint)

  desc "lint application javascript"
  task :coffeelint do
    config_file = ENV['config_file'] || '.coffeelint.json'
    directories = ENV['directories'].try(:split, ',') || ['app/assets/javascripts', 'spec/javascripts']

    failures = 0
    directories.each do |dir|
      failures += Coffeelint.run_test_suite(dir, config_file: config_file)
    end
    fail "Lint!" unless failures == 0
  end
rescue LoadError
  puts 'coffeelint load error'
end
