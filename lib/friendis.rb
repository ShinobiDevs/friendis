require 'redis'
require "friendis/version"
require 'friendis/configuration'
require 'friendis/friendable'

module Friendis

  attr_reader :configuration

  def self.configure(&block)
    @configuration = Friendis::Configuration.new
    yield(@configuration)
  end

  def self.redis
    @configuration.redis_connection ||= Redis.new
  end

  # Your code goes here...
end
