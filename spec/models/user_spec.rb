require 'spec_helper'

describe User do

  before do
    @user = Factory(:user)
    @omniauth = {"user_info" => {"name" => "Jim Joe", "location" => "San Francisco"},
        "provider"=>"twitter","uid"=>"12345",
        "credentials"=>{"token"=>"abc123","secret"=>"xyz456"}}
  end

  describe "age" do
    it "should return the users age" do
      @age = User.new
      user_age = @age.age(Date.parse("1986-09-07"))
      user_age.should == 24
    end
  end

  describe "#build_athentications" do
    before do
      @test = User.new.apply_omniauth(@omniauth)
    end

    it "should add an authentication" do
      @test.provider.should == "twitter"
      @test.uid.should == "12345"
      @test.access_token.should == "abc123"
      @test.access_secret.should == "xyz456"
    end
  end

  describe "#twitter_client" do
    before do
      @auth = Factory(:authentication)
    end

    it "should return a new Twitter client" do
      @twitter = User.new.twitter_user(@user.id)
      @twitter.should be_a Twitter::Client
    end

    it "should not return a new Twitter client" do
      @twitter = User.new.twitter_user(999999)
      @twitter.should be_nil
    end
  end

  describe "#facebook_client" do
    before do
      @auth = Factory(:authentication, :provider => "facebook")
    end

    it "should return a new Facebook client" do
      @facebook = User.new.facebook_user(@user.id)
      @facebook.should be_a FbGraph::User
    end

    it "should not reutrn a new Facebook client" do
      @facebook = User.new.facebook_user(99999)
      @facebook.should be_nil
    end
  end
end

