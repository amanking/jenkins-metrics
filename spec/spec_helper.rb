$: << File.join(File.dirname(__FILE__), '../lib')
require 'rspec'

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.filter_run_excluding :broken => true
end