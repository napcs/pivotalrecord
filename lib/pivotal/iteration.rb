module Pivotal
  
  #==Iteration
  # An iteration maps to a Pivotal Project and represents the sprint.
  class Iteration < Pivotal::Base
   
    belongs_to :project
    
    attr_accessor :start, :finish, :id, :stories, :number

    def self.parse_result(iteration)
      Pivotal::Iteration.new( :id => get_content_for(iteration["id"]),
                              :number => get_content_for(iteration["number"]),
                              :start => get_content_for(iteration["start"]),
                              :finish => get_content_for(iteration["finish"]),                         
                              :stories => Pivotal::Story.parse_results(iteration["stories"].first)
                               )
    end 
    
  end
end