module Pivotal
  
  module ProjectFinders
    
  end
  
  module IterationFinders

    
  end
  
  module StoryFinders
    
    def accepted
      find_all_by_current_state "accepted"
    end
    
    def bugs
      find_all_by_story_type "bug"
    end
    
    def features
      find_all_by_story_type "feature"
    end
    
    def chores
      find_all_by_story_type "chore"
    end
    
    def releases
      find_all_by_story_type "releoase"
    end
    
    def find_all_by_story_type(type)
      Pivotal::CollectionProxy.new Story, @records.select{|s| s.story_type == type.to_s}
    end
    
    def find_all_by_current_state(current_state)
      Pivotal::CollectionProxy.new Story, @records.select{|s| s.current_state == current_state.to_s}
    end
    
  end
  
  class CollectionProxy
    def initialize(source, records)
      @source = source
      @records = records
      self.send :extend, "#{source}Finders".constantize
    end 
    
    def inspect
      @records.inspect
    end
    
    def all
      @records
    end

    def method_missing(name, *args, &block) 
      @records.send(name, *args, &block) 
    end
    
    
  end
  
end