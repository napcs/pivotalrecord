module Pivotal
  # The class that keeps track of the global options for Haml within Rails.
  module Configuration
    extend self

    @options = {}
    # The options hash for the Pivotal library.
    # Pivotal::Configuration.options[:api_key] = "something"
    attr_accessor :options
  end
end