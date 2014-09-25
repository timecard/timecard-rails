# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load configuration early
require_relative "initializers/rails_config"

# Initialize the Rails application.
Timecard::Application.initialize!
