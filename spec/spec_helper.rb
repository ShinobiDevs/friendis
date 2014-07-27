require 'bundler/setup'
Bundler.setup

require 'friendis' # and any other gems you need

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end