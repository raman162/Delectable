begin
	require 'simplecov'
	SimpleCov.start
rescue LoadError
	puts "Coverage Disabled"
end


$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'delectable'
require 'delectable/food.rb'
require 'delectable/menuItem.rb'
require 'delectable/menu.rb'
require 'delectable/order.rb'
require 'delectable/admin.rb'
require 'yaml'