require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Pivotal::Iteration do
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
  
  
  describe "with many iterations" do
    before(:each) do
      xml = %Q{<?xml version="1.0" encoding="UTF-8"?>
      <iterations type="array">
        <iteration>
          <id type="integer">1</id>
          <number type="integer">1</number>
          <start type="datetime">2009/01/12 00:00:00 UTC</start>
          <finish type="datetime">2009/01/19 00:00:00 UTC</finish>
          <stories type="array">
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
            </story>
          </stories>
        </iteration>
        <iteration>
          <id type="integer">2</id>
          <number type="integer">2</number>
          <start type="datetime">2009/01/19 00:00:00 UTC</start>
          <finish type="datetime">2009/01/26 00:00:00 UTC</finish>
          <stories type="array">
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
            </story>
          </stories>
        </iteration>
        <iteration>
          <id type="integer">3</id>
          <number type="integer">3</number>
          <start type="datetime">2009/01/26 00:00:00 UTC</start>
          <finish type="datetime">2009/02/02 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">4</id>
          <number type="integer">4</number>
          <start type="datetime">2009/02/02 00:00:00 UTC</start>
          <finish type="datetime">2009/02/09 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">5</id>
          <number type="integer">5</number>
          <start type="datetime">2009/02/09 00:00:00 UTC</start>
          <finish type="datetime">2009/02/16 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">6</id>
          <number type="integer">6</number>
          <start type="datetime">2009/02/16 00:00:00 UTC</start>
          <finish type="datetime">2009/02/23 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">7</id>
          <number type="integer">7</number>
          <start type="datetime">2009/02/23 00:00:00 UTC</start>
          <finish type="datetime">2009/03/02 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">8</id>
          <number type="integer">8</number>
          <start type="datetime">2009/03/02 00:00:00 UTC</start>
          <finish type="datetime">2009/03/09 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">9</id>
          <number type="integer">9</number>
          <start type="datetime">2009/03/09 00:00:00 UTC</start>
          <finish type="datetime">2009/03/16 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">10</id>
          <number type="integer">10</number>
          <start type="datetime">2009/03/16 00:00:00 UTC</start>
          <finish type="datetime">2009/03/23 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">11</id>
          <number type="integer">11</number>
          <start type="datetime">2009/03/23 00:00:00 UTC</start>
          <finish type="datetime">2009/03/30 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">12</id>
          <number type="integer">12</number>
          <start type="datetime">2009/03/30 00:00:00 UTC</start>
          <finish type="datetime">2009/04/06 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">13</id>
          <number type="integer">13</number>
          <start type="datetime">2009/04/06 00:00:00 UTC</start>
          <finish type="datetime">2009/04/13 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">14</id>
          <number type="integer">14</number>
          <start type="datetime">2009/04/13 00:00:00 UTC</start>
          <finish type="datetime">2009/04/20 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">15</id>
          <number type="integer">15</number>
          <start type="datetime">2009/04/20 00:00:00 UTC</start>
          <finish type="datetime">2009/04/27 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">16</id>
          <number type="integer">16</number>
          <start type="datetime">2009/04/27 00:00:00 UTC</start>
          <finish type="datetime">2009/05/04 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">17</id>
          <number type="integer">17</number>
          <start type="datetime">2009/05/04 00:00:00 UTC</start>
          <finish type="datetime">2009/05/11 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">18</id>
          <number type="integer">18</number>
          <start type="datetime">2009/05/11 00:00:00 UTC</start>
          <finish type="datetime">2009/05/18 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">19</id>
          <number type="integer">19</number>
          <start type="datetime">2009/05/18 00:00:00 UTC</start>
          <finish type="datetime">2009/05/25 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">20</id>
          <number type="integer">20</number>
          <start type="datetime">2009/05/25 00:00:00 UTC</start>
          <finish type="datetime">2009/06/01 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">21</id>
          <number type="integer">21</number>
          <start type="datetime">2009/06/01 00:00:00 UTC</start>
          <finish type="datetime">2009/06/08 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">22</id>
          <number type="integer">22</number>
          <start type="datetime">2009/06/08 00:00:00 UTC</start>
          <finish type="datetime">2009/06/15 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">23</id>
          <number type="integer">23</number>
          <start type="datetime">2009/06/15 00:00:00 UTC</start>
          <finish type="datetime">2009/06/22 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">24</id>
          <number type="integer">24</number>
          <start type="datetime">2009/06/22 00:00:00 UTC</start>
          <finish type="datetime">2009/06/29 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">25</id>
          <number type="integer">25</number>
          <start type="datetime">2009/06/29 00:00:00 UTC</start>
          <finish type="datetime">2009/07/06 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">26</id>
          <number type="integer">26</number>
          <start type="datetime">2009/07/06 00:00:00 UTC</start>
          <finish type="datetime">2009/07/13 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">27</id>
          <number type="integer">27</number>
          <start type="datetime">2009/07/13 00:00:00 UTC</start>
          <finish type="datetime">2009/07/20 00:00:00 UTC</finish>
          <stories type="array">
          </stories>
        </iteration>
        <iteration>
          <id type="integer">28</id>
          <number type="integer">28</number>
          <start type="datetime">2009/07/20 00:00:00 UTC</start>
          <finish type="datetime">2009/07/27 00:00:00 UTC</finish>
          <stories type="array">
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
            </story>
          </stories>
        </iteration>
      </iterations>}
      url = "#{@service}/projects/4860/iterations?token=#{@token}"
      FakeWeb.register_uri(:get, url, :string => xml, :content_type => "application/xml", :status => ["200", "OK"])
      @project = Pivotal::Iteration.new("id" => "4860", :name => "FeelMySkills")
    end
    it "should get iterations" do
      iterations = Pivotal::Iteration.find_all_by_project_id(@project.id)
      iterations.each{|i| i.should be_a Pivotal::Iteration}
      iterations.detect{|i| i.number == 28}.should be_true

    end
  end
  
  
end