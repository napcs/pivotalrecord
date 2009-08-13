require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Pivotal::Project do
  before(:each) do
    @service = "http://www.pivotaltracker.com/services/v2"
    @token = "abcd"
    Pivotal::Configuration.options[:api_key] = @token
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = false
  end
  
  after(:each) do
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
  
  it "should create a new instance" do
    p = Pivotal::Project.new "name" => "Hello", "id" => "1234"
    p.name.should == "Hello"
    p.id.should == "1234"
  end
  
  describe "with a project" do
    
    before(:each) do
      xml = %Q{<?xml version="1.0" encoding="UTF-8"?>
      <project>
        <id>4860</id>
        <name>FeelMySkills</name>
        <iteration_length type="integer">1</iteration_length>
        <week_start_day>Monday</week_start_day>
        <point_scale>0,1,2,3</point_scale>
      </project>}
      url = "#{@service}/projects/4860?token=#{@token}"
      FakeWeb.register_uri(:get, url, :string => xml, :content_type => "application/xml", :status => ["200", "OK"])
      
    end
    it "should get the project" do
      p = Pivotal::Project.find_by_id(4860)
      p.name.should == "FeelMySkills"
    end
    it "should still have the raw attributes" do
      p = Pivotal::Project.find_by_id(4860)
      p.original_hash.should == {"name"=>["FeelMySkills"], "iteration_length"=>[{"type"=>"integer", "content"=>"1"}], "week_start_day"=>["Monday"], "point_scale"=>["0,1,2,3"], "id"=>["4860"]}
      
    end
    
    describe "stories" do
      before(:each) do
        xml = %Q{<?xml version="1.0" encoding="UTF-8"?>
        <stories type="array" count="14" total="14">
          <story>
            <id type="integer">300970</id>
            <story_type>release</story_type>
            <url>http://www.pivotaltracker.com/story/show/300970</url>
            <current_state>accepted</current_state>
            <description></description>
            <name>rel_1-1-5</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 03:00:57 UTC</created_at>
            <accepted_at type="datetime">2009/01/14 06:32:15 UTC</accepted_at>
            <deadline type="datetime">2008/12/12 20:00:00 UTC</deadline>
            <iteration>
              <number>1</number>
              <start type="datetime">2009/01/12 00:00:00 UTC</start>
              <finish type="datetime">2009/01/19 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">302045</id>
            <story_type>bug</story_type>
            <url>http://www.pivotaltracker.com/story/show/302045</url>
            <current_state>accepted</current_state>
            <description>CSS stylesheets for greybox are still referenced in templates causing errors in the logs</description>
            <name>Remove references to Greybox</name>
            <requested_by>Brian Hogan</requested_by>
            <owned_by>Brian Hogan</owned_by>
            <created_at type="datetime">2008/12/04 18:46:43 UTC</created_at>
            <accepted_at type="datetime">2009/01/19 17:22:53 UTC</accepted_at>
            <iteration>
              <number>2</number>
              <start type="datetime">2009/01/19 00:00:00 UTC</start>
              <finish type="datetime">2009/01/26 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300931</id>
            <story_type>bug</story_type>
            <url>http://www.pivotaltracker.com/story/show/300931</url>
            <current_state>accepted</current_state>
            <description>The home page has no title set.</description>
            <name>Get a title on the home page</name>
            <requested_by>Brian Hogan</requested_by>
            <owned_by>Brian Hogan</owned_by>
            <created_at type="datetime">2008/12/04 02:22:00 UTC</created_at>
            <accepted_at type="datetime">2009/01/19 17:23:11 UTC</accepted_at>
            <iteration>
              <number>2</number>
              <start type="datetime">2009/01/19 00:00:00 UTC</start>
              <finish type="datetime">2009/01/26 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300939</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300939</url>
            <estimate type="integer">1</estimate>
            <current_state>started</current_state>
            <description>Images need to be linked and modalbox needs testing in other browsers besides FF and Safari.</description>
            <name>Finish modalbox implementation</name>
            <requested_by>Brian Hogan</requested_by>
            <owned_by>Brian Hogan</owned_by>
            <created_at type="datetime">2008/12/04 02:33:33 UTC</created_at>
            <iteration>
              <number>28</number>
              <start type="datetime">2009/07/20 00:00:00 UTC</start>
              <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300495</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300495</url>
            <estimate type="integer">3</estimate>
            <current_state>started</current_state>
            <description>Choose an item, edit it, and notice that the dropdown for file / url is not selected on load, causing the file or url field to not display.</description>
            <name>Editing an item does not select the correct type</name>
            <requested_by>Brian Hogan</requested_by>
            <owned_by>Brian Hogan</owned_by>
            <created_at type="datetime">2008/12/04 01:55:39 UTC</created_at>
            <iteration>
              <number>28</number>
              <start type="datetime">2009/07/20 00:00:00 UTC</start>
              <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300423</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300423</url>
            <estimate type="integer">3</estimate>
            <current_state>started</current_state>
            <description>A profile should be viewable using the iPhone or Touch. 
        The profile page should link to the portfolios.
        items should display within the portfolios.</description>
            <name>iPhone interface for viewing profiles</name>
            <requested_by>Brian Hogan</requested_by>
            <owned_by>Brian Hogan</owned_by>
            <created_at type="datetime">2008/12/04 01:48:53 UTC</created_at>
            <iteration>
              <number>28</number>
              <start type="datetime">2009/07/20 00:00:00 UTC</start>
              <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300923</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300923</url>
            <estimate type="integer">1</estimate>
            <current_state>unstarted</current_state>
            <description>Add a &quot;contact us&quot; form that sends an email</description>
            <name>Contact Us form</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 02:14:51 UTC</created_at>
            <iteration>
              <number>28</number>
              <start type="datetime">2009/07/20 00:00:00 UTC</start>
              <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">300518</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300518</url>
            <estimate type="integer">1</estimate>
            <current_state>unstarted</current_state>
            <description>Add a send to friend link on portfolios</description>
            <name>Send To Friend linke</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 01:57:22 UTC</created_at>
            <iteration>
              <number>28</number>
              <start type="datetime">2009/07/20 00:00:00 UTC</start>
              <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
            </iteration>
          </story>
          <story>
            <id type="integer">306550</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/306550</url>
            <estimate type="integer">1</estimate>
            <current_state>unscheduled</current_state>
            <description>&quot;less than one year&quot; looks kinda funny. Can we do months instead?</description>
            <name>Show months for skills less than one year</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/09 17:28:40 UTC</created_at>
          </story>
          <story>
            <id type="integer">300932</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300932</url>
            <estimate type="integer">1</estimate>
            <current_state>unscheduled</current_state>
            <description></description>
            <name>Add meta tags to pro accounts</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 02:22:36 UTC</created_at>
          </story>
          <story>
            <id type="integer">300927</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300927</url>
            <estimate type="integer">3</estimate>
            <current_state>unscheduled</current_state>
            <description>Allow people to buy an annual subscription for a pro account. use paypal for this first iteration. Payments should be $25 a year for pro accounts. Look into recurring billing.</description>
            <name>Implement Pro account subscription</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 02:19:59 UTC</created_at>
          </story>
          <story>
            <id type="integer">300924</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300924</url>
            <estimate type="integer">1</estimate>
            <current_state>unscheduled</current_state>
            <description></description>
            <name>Implement Exception Notification plugin</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 02:15:15 UTC</created_at>
          </story>
          <story>
            <id type="integer">300800</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300800</url>
            <estimate type="integer">3</estimate>
            <current_state>unscheduled</current_state>
            <description>Request recommendations from people. People receive an email asking for the recommendation. A link in the email takes them to a special URL where they enter a plain-text recommendation. They can also opt out of making the recommendation. Opting out reduces the skill score by 1000 points. Recommendations are worth 1000 points each.</description>
            <name>Add Recommendations</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 02:14:16 UTC</created_at>
          </story>
          <story>
            <id type="integer">300472</id>
            <story_type>feature</story_type>
            <url>http://www.pivotaltracker.com/story/show/300472</url>
            <estimate type="integer">1</estimate>
            <current_state>unscheduled</current_state>
            <description>Web site thumbnails are coming from Thumbalizer. Should we make a method to fetch those images and store them locally? </description>
            <name>Deal with web thumbnails</name>
            <requested_by>Brian Hogan</requested_by>
            <created_at type="datetime">2008/12/04 01:53:56 UTC</created_at>
          </story>
        </stories>}
        url = "#{@service}/projects/4860/stories?token=#{@token}"
        FakeWeb.register_uri(:get, url, :string => xml, :content_type => "application/xml", :status => ["200", "OK"])
        @project = Pivotal::Project.new("id" => "4860", :name => "FeelMySkills")
        
      end
      
      it "should get stories" do
        @project.stories.should_not == []
      end
      
    end
    
  end
  
  describe "With projects" do
    
    before(:each) do

      xml = %Q{<?xml version="1.0" encoding="UTF-8"?>
      <projects type="array">
        <project>
          <id>4860</id>
          <name>FeelMySkills</name>
          <iteration_length type="integer">1</iteration_length>
          <week_start_day>Monday</week_start_day>
          <point_scale>0,1,2,3</point_scale>
        </project>
        <project>
          <id>20273</id>
          <name>Rails Mentors</name>
          <iteration_length type="integer">1</iteration_length>
          <week_start_day>Monday</week_start_day>
          <point_scale>0,1,2,3</point_scale>
        </project>
        <project>
          <id>11172</id>
          <name>rPulse</name>
          <iteration_length type="integer">1</iteration_length>
          <week_start_day>Monday</week_start_day>
          <point_scale>0,1,2,3</point_scale>
        </project>
        <project>
          <id>12510</id>
          <name>snippetstash</name>
          <iteration_length type="integer">1</iteration_length>
          <week_start_day>Monday</week_start_day>
          <point_scale>0,1,2,3</point_scale>
        </project>
      </projects>}
      url = "#{@service}/projects?token=#{@token}"
      FakeWeb.register_uri(:get, url, :string => xml, :content_type => "application/xml", :status => ["200", "OK"])
    
    end
    

    
    it "should should create an array of four projects" do
      projects = Pivotal::Project.find_all
      projects.length.should == 4
      projects.each{|project| project.should be_a(Pivotal::Project)}
      projects.detect{|project| project.name == "snippetstash"}
      projects.detect{|project| project.name == "Rails Mentors"}
      projects.detect{|project| project.name == "rPulse"}
      projects.detect{|project| project.name == "FeelMySkills"}
    end
  end
  
end