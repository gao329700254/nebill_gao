RSpec::Matchers.define :have_header_title do |expected|
  match do |actual|
    actual.has_css? '#header .header__title', text: expected
  end
end
