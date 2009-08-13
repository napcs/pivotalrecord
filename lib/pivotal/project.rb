module Pivotal
  #==Project
  # Your project in PivotalTracker. Use the project to get basic info
  # and to get its stories.
  class Project < Pivotal::Base
      
    set_fields :name, :original_hash
  
    has_many :stories  
    has_many :iterations
    
    
    def backlog()
      Pivotal::Iteration.backlog_for(self.id)
    end
    
  end
end