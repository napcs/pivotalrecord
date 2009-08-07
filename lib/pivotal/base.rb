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
      def parse_results(results)
        return [] if results[self.resource].nil?
        results[self.resource].collect do |item|
          klass = self.name.constantize
          klass.parse_result(item)
        end
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
        parent_resource = resource
        object = things.to_s.classify
        class_eval <<-EOF
          
          def #{things}
            Pivotal::#{object}.find_all_by_parent_id("#{parent_resource.pluralize}", self.id)
          end
          
        EOF
      end
      
      # Creates a reverse association, making it easy to grab
      # the parent object.
      def belongs_to(parent)
        object  = parent.to_s.classify
        parent_id = "#{parent.to_s.downcase}_id"
        class_eval <<-EOF
          
          def #{parent.to_s}
            Pivotal::#{object}.find_by_id(#{parent_id})
          end
          
          def self.find_all_by_#{parent.to_s}_id(id)
            find_all_by_parent_id("#{parent.to_s.pluralize}", id)
          end

        EOF
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
      
      # Base find method
      def find(type)
        if type == :all
          find_all
        else
          find_by_id(type)
        end
      end
      
      # find a specific record by id
      def find_by_id(id)
        query = "#{self.url}/#{self.resource.pluralize}/#{id}?token=#{self.token}"
        puts "query : #{query}" if self.debugging?
        results = RestClient.get query
        result = XmlSimple.xml_in(results.to_s)
        parse_result(result)
      end
          
      # generic finder, used by associations
      def find_all_by_parent_id(parent, id)
        return [] if id.nil?
        query = "#{self.url}/#{parent}/#{id}/#{self.resource.pluralize}?token=#{self.token}"
        puts "query : #{query}" if self.debugging?
        results = RestClient.get query
        results = XmlSimple.xml_in(results.to_s)
        parse_results(results)
      end
  
      # find all records for the given object.
      def find_all
        query ="#{self.url}/#{self.resource.pluralize}?token=#{self.token}"
        puts "query : #{query}" if self.debugging?
        results = RestClient.get query
        puts results.inspect if self.debugging?
        results = XmlSimple.xml_in(results.to_s)
        parse_results(results)
      end
  

  
  
    end
  
  end
end