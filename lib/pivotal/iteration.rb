module Pivotal
  
  #==Iteration
  # An iteration maps to a Pivotal Project and represents the sprint.
  class Iteration < Pivotal::Base
   
    belongs_to :project   
    
    set_fields :start, :finish, :number

    def stories
      @stories ||= self.original_hash["stories"].nil? ? [] : Pivotal::Story.parse_results(original_hash["stories"].first)
    end
  
  
    def self.backlog
      
    end
  end
end