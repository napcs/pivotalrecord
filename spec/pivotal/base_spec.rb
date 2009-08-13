require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Pivotal::Base do
  before(:each) do
    @service = "http://www.pivotaltracker.com/services/v2"
    @token = "abcd"
    Pivotal::Configuration.options[:api_key] = @token
  end
  describe "with options" do
    it "should return just the token" do
      Pivotal::Base.parse_options(Hash.new).should == "?token=#{@token}"
    end
    it "should return backlog with token" do
      Pivotal::Base.parse_options(:iteration => :backlog).should == "backlog?token=#{@token}"
    end
    
    it "should return backlog with token and limit" do
      Pivotal::Base.parse_options(:limit => 10, :iteration => :backlog).should == "backlog?token=#{@token}&limit=10"
    end
    
    it "should return backlog with token and limit and offset" do
      Pivotal::Base.parse_options(:limit => 10, :offset => 2, :iteration => :backlog).should == "backlog?token=#{@token}&limit=10&offset=2"
    end
    
    it "should return with token and limit and offset but no backlog" do
      Pivotal::Base.parse_options(:limit => 10, :offset => 2).should == "?token=#{@token}&limit=10&offset=2"
    end
    
    it "should create a filter for features that need feedback" do
      Pivotal::Base.parse_filter(:type => "feature", :label => "needs feedback").should == "filter=type%3A%22feature%22%20label%3A%22needs%20feedback%22"
    end
    
    it "should return all stories that are features, limited by 5" do
      Pivotal::Base.parse_options(:limit => 10, :filter => {:type => "feature", :label => "needs feedback"}).should == "?token=#{@token}&limit=10&filter=type%3A%22feature%22%20label%3A%22needs%20feedback%22"
    end
    
  end
  
end