module Pivotal
  class Project < Pivotal::Base
      
    attr_accessor :id, :name
  
    has_many :stories  

    
    def self.parse_result(project)
      puts project.inspect
      Pivotal::Project.new( :id => get_content_for(project["id"]),
                            :name => get_content_for(project["name"]) )
    end
    
    
  end
end