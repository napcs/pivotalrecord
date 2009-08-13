module Pivotal
  class Base
    
    def initialize(args = {})
      args.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end
    end
  
    
    class << self 
      
      # parses the collection from Pivotal. Invokes the class's parse_result method
      # which the class should implement.
      def parse_results(results, options)
        return [] if results[self.resource].nil?
        results[self.resource].collect do |item|
          klass = self.name.constantize
          klass.parse_result(item, options)
        end
      end
      
      def parse_result(data, options)
        klass = self.name.constantize
        attributes = {}
        self.fields.each do |field|
          attributes[field.to_sym] = get_content_for(data[field.to_s])
        end
        attributes[:original_hash] = data
        result = klass.new attributes
        result.project_id = options[:project_id] if result.respond_to?("project_id") && !options[:project_id].blank?
        result.story_id = options[:story_id] if result.respond_to?("story_id") && !options[:story_id].blank?
        
        result
      end
      
      
      # get_content_for is used to convert the strings in the xml fil
      # into actual Ruby types.
      # The element can come in as a string, an array with a string inside
      # or a hash, so I'm covering all bases here.
      # Don't change without using the specs!
      def get_content_for(element)
        result =  if element.is_a? String
          element.to_s
        elsif element.nil?
          nil #doesn't exist
        else
          if element[0].is_a? Hash
            type = element[0]["type"]
            content = element[0]["content"]
            cast_value(content, type)
          else
            element[0].to_s
          end
          
        end
      end

      def cast_value(content, type)
        value = case type
              when "integer"
                 content.to_i
              when "datetime"
                 content.to_time
              else
                content
              end
      end
      
      def resource
        name.split('::').last.downcase
      end
    
      
      # Declares the relationship between the models.
      #
      #  has_many :stories
      #
      # Creates a <tt>stories</tt> method to retrive the related records. 
      def has_many(things)
        parent_id = "#{resource}_id"
        object = things.to_s.classify
        
        
        class_eval <<-EOF
          
          def #{things}(options ={})
            options.merge!(:#{parent_id} => id)
            @#{things} = Pivotal::#{object}.find_all(options)
          end
          
        EOF
      end
      
      # Creates a reverse association, making it easy to grab
      # the parent object.
      def belongs_to(parent)
        
        object  = parent.to_s.classify
        parent_id = "#{parent.to_s.downcase}_id"
        
        if parent.to_s == "project"
          attr_accessor parent_id.to_sym
        else
          attr_accessor parent_id.to_sym, :project_id 
        end
        
        class_eval <<-EOF
      
          def #{parent.to_s}
            @#{parent.to_s} = Pivotal::#{object}.find_by_id(#{parent_id})
          end
          
          
          def self.find_all_by_#{parent.to_s}_id(id, options={})
            options.merge!(:#{parent_id} => id)
            find_all(options)
          end
          
          def self.find_by_#{parent.to_s}_id_and_id(parent_id, id, options = {})
            options.merge!(:#{parent_id} => parent_id)
            find_by_id(id, options)
          end
          
          

        EOF
      end
      
      def set_fields(*fields)
        attr_accessor :id, :original_hash
        fields.each {|field| attr_accessor field }
        @fields = fields
        @fields << :id
      end
      
      def fields
        @fields
      end
      
      # Retrives the token from the configuration
      def token
        @@token = Pivotal::Configuration.options[:api_key]
      end
      
      def debugging?
        @@debugging = Pivotal::Configuration.options[:debug] == true
      end
  
      # retrieves the service url
      # If not set in the configuration, the default
      # value is used.
      def url
        @@url = Pivotal::Configuration.options[:url] || "http://www.pivotaltracker.com/services/v2"
      end
      
      # Convenience method for finding all objects. Options are supported
      def all(options = {})
        self.find :all, options
      end
      
      # Convenience method for finding the first object. Options are supported
      def first(options = {})
        self.find :first, options
      end
      
      # Find records. See find_by_id for options.
      #
      #  Pivotal::Project.find :all
      #  Pivotal::Project.find :first
      #  Pivotal::Project.find 2552
      def find(type, options = {})
        if type == :all
          find_all options
        elsif type == :first
          find_one options.merge(:limit => 1)  
        else
          find_by_id(type, options)
        end
      end
      
      # find a specific record by id.
      # Options:
      # * <tt>:filter</tt> - a hash for finding records by label and type.
      #  
      #  :filter => {:label => "Needs approval", :type => "feature"}
      # * <tt>:limit</tt> - limit the number of records that come back.
      # * <tt>:offest</tt> - for pagination
      # 
      # Additonally, you may need to provide a hierarchy if you're referencing a Story or an Iteration.
      #
      #  Pivotal::Story.find_by_id 25, :project_id => 2534
      
      def find_by_id(id, options = {})
        get_result(id, options)
      end
            
      # find all records for the given object.
      def find_all(options ={})
        get_results(options)
      end
      
      def find_one(options ={})
        # get_results is going to return a proxy. I am only expecting one record.
        get_results(options).first
      end
      
      def base_path(options)
        path = "projects"
        path << "/#{options[:project_id]}/stories" if options[:project_id]
        path << "/stories/#{options[:story_id]}/tasks" if options[:story_id]
        path
      end
      
      def get_results(options={})
        path = base_path(options)
        opts = parse_options(options)
        query ="#{self.url}/#{path}#{opts}"
        puts "query : #{query}" #if self.debugging?
        results = RestClient.get query
        results = XmlSimple.xml_in(results.to_s)
        results = parse_results(results, options)
        CollectionProxy.new(self.name.constantize, results)
        
      end
      
      def get_result(id, options ={})
          path = base_path(options)
          opts = parse_options(options)
          query = "#{self.url}/#{path}/#{id}#{opts}"
          puts "query : #{query}" #if self.debugging?
          results = RestClient.get query
          result = XmlSimple.xml_in(results.to_s)
          parse_result(result, options)
      end
      
      def parse_options(options)
        if options[:iteration].blank?
          opts = ["?token=#{self.token}"]
        else
          opts = ["#{options[:iteration].to_s}?token=#{self.token}"]
        end
        
        if options[:limit]
          opts << "limit=#{options[:limit]}"
        end
        
        if options[:offset]
          opts << "offset=#{options[:offset]}"
        end
        
        if options[:filter]
          opts << parse_filter(options[:filter])
        end
        
        
        return opts.join("&")
        
      end


      def parse_filter(opts)
         opts = opts.map{|key, value| "#{key}:\"#{value}\""}.join " "
         opts = URI.escape(opts, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
         opts = "filter=#{opts}"
         
      end
  
  

  
    end
  
  end
end