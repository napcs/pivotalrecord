begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end
 
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'pivotal'
require 'fakeweb'

Spec::Runner.configure do |config|
  config.mock_with :mocha

end