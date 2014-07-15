if defined?(Konacha)
  require 'capybara/poltergeist'
  Konacha.configure do |c|
    c.spec_dir = "spec/javascripts"
    c.driver = :poltergeist
  end
end
