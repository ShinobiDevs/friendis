require 'spec_helper.rb'

describe Friendis::Configuration do

  before(:each) do
    @configuration = Friendis::Configuration.new
  end

  describe "#redis_connection" do
    it "should have accessors for #redis_connection" do
      @configuration.should respond_to(:redis_connection)
      @configuration.should respond_to(:redis_connection=)
    end
  end

end
