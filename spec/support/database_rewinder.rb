RSpec.configure do |config|
  config.before(:suite) do
    DatabaseRewinder.clean_with :truncation
  end
  config.before :each do
    DatabaseRewinder.strategy = :transaction
  end
  config.before :each, js: true do
    DatabaseRewinder.strategy = :truncation, { pre_count: true }
  end
  config.before :each do
    DatabaseRewinder.start
  end
  config.after :each do
    DatabaseRewinder.clean
  end
end
