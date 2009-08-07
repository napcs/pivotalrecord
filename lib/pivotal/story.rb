module Pivotal
  class Story < Pivotal::Base
  
    attr_accessor :id, :project_id, :name, :description, :url, :estimate, :story_type, :accepted_at
  
 
    
    belongs_to :project
    
    private

    
    def self.parse_result(story)
      Pivotal::Story.new( 
        :id => get_content_for(story["id"]),
        :name => get_content_for(story["name"]),
        :description => get_content_for(story["description"]),
        :url => get_content_for(story["url"]),
        :estimate => get_content_for(story["estimate"]),
        :story_type => get_content_for(story["story_type"]),
        :accepted_at => get_content_for(story["accepted_at"]),
        :current_state => get_content_for(story["current_state"])
       )
    end
  
  
  
  
  end
end