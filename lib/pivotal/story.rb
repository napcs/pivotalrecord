module Pivotal
  class Story < Pivotal::Base
  
    set_fields :name, :description, :url, :estimate, :story_type, :accepted_at, :current_state
    
    belongs_to :project
    
    

    
  end
end
