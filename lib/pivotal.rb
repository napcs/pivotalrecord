$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'activesupport'
require 'rest_client'
require 'xmlsimple'
require 'uri'

require 'pivotal/base'
require 'pivotal/configuration'
require 'pivotal/project'
require 'pivotal/story'
require 'pivotal/iteration'
require 'pivotal/collection_proxy'