require 'spec_helper'

describe Friendis do
  
  describe '#configure' do

    it "should respond to #configure" do
      Friendis.should respond_to(:configure)
    end
  end

  describe "#redis" do
    it "should return a default connection if no redis connection specified in configuration" do
      Friendis.configure do |c|
        c.redis_connection = nil
      end
      Friendis.redis.should_not be_nil
    end

  end

end