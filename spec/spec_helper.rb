$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'vcr'

require 'cleverbot'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  # config.treat_symboles_as_metadata_keys_with_true_values = true
  config.around(:each, :vcr) do |example|
    VCR.use_cassette("cleverbot", :record => :new_episodes) { example.call }
  end
end
