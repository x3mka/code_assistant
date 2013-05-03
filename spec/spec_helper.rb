require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.color = true
  config.fail_fast = false
end

FIXTURE_PATH = File.expand_path("../fixtures", __FILE__)

def fixture(file)
  File.new(FIXTURE_PATH + '/' + file)
end

def html_response(file)
  {
      :body => fixture(file),
      :headers => {
          :content_type => 'text/html; charset=utf-8'
      }
  }
end
