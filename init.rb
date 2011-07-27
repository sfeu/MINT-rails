# Include hook code here
# Include hook code here
require 'rubygems'
require "bundler/setup"
require "MINT-core"
require 'dm-core'
DataMapper.setup(:default, { :adapter => "rinda", :host =>"localhost",:port=>4000})

# required dependencies
#Rails::Initializer.run do |config|
#  config.gem 'MINT-core', :version => '0.0.1'
#  config.gem "em-websocket", :version => "0.1.3"
#  config.gem "juggernaut", :version => "2.0.0"
#  config.gem "json", :version=> "1.5.1"
#end

