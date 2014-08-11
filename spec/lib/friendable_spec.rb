require 'spec_helper'
require 'models/user'

describe Friendis::Friendable do

  # Configure Friendis, so it can be used
  before(:all) do
    Friendis.configure do |c|
    end
  end

  describe "#send_friend_request" do
    before(:each) do 
      @user1 = User.new(1)
      @user2 = User.new(2)
      @user1.clear_friendis_data
      @user2.clear_friendis_data

      @user1.save
      @user2.save
      @user1.send_friend_request(@user2)
    end

    it "should indicate a friend request was sent" do
      @user1.sent_friend_requests.should_not be_empty
      @user1.sent_friend_requests.first["name"].should eq(@user2.name)
    end

    it "should indicate an incoming friend request" do
      @user2.pending_friend_requests.should_not be_empty
    end
  end

  describe "#approve_friend_request" do
    before(:each) do 
      @user1 = User.new(1)
      @user2 = User.new(2)
      @user1.clear_friendis_data
      @user2.clear_friendis_data

      @user1.save
      @user2.save
      @user1.send_friend_request(@user2)
    end

    it "should show friend on friends list after approval" do
      @user2.approve_friend_request(@user1).should be_truthy
      @user2.friends.first["name"].should eq(@user1.name)
      @user1.friends.first["name"].should eq(@user2.name)
    end
  end

  describe "#unfriend" do
    before(:each) do 
      @user1 = User.new(1)
      @user2 = User.new(2)
      @user1.clear_friendis_data
      @user2.clear_friendis_data

      @user1.save
      @user2.save
      @user1.send_friend_request(@user2)
      @user2.approve_friend_request(@user1)
    end

    it "should show friend on friends list after approval" do
      @user1.unfriend(@user2).should be_truthy
      @user1.friends.should be_empty
      @user2.friends.should be_empty
    end
  end

  describe "#is_friends_with?" do
    before(:each) do 
      @user1 = User.new(1)
      @user2 = User.new(2)
      @user3 = User.new(3)

      @user1.clear_friendis_data
      @user2.clear_friendis_data
      @user3.clear_friendis_data

      @user1.save
      @user2.save
      @user3.save

      @user1.send_friend_request(@user2)
      @user2.approve_friend_request(@user1)
    end

    it "should return true if users are friends" do
      @user1.is_friends_with?(@user2).should be_truthy
    end

    it "should return false if users aren't friends" do
      @user1.is_friends_with?(@user3).should be_falsy
    end

  end

end
