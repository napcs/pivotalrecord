module Pivotal
  #==Project
  # Your project in PivotalTracker. Use the project to get basic info
  # and to get its stories.
  class Project < Pivotal::Base
      
    attr_accessor :id, :name
  
    has_many :stories  

    
    def self.parse_result(project)
      Pivotal::Project.new( :id => get_content_for(project["id"]),
                            :name => get_content_for(project["name"]) )
    end
    
    
  end
end