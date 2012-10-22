# -- coding: utf-8

require "pp"
require "rubygems"
require "rspec-expectations"
require "rspec/matchers/built_in/be"
Dir["./spec/support/**/*.rb"].each{|file| require file }

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start
end

require File.expand_path("../../lib/masque.rb", __FILE__)


RSpec.configure do |config|
  Capybara.app = Dummy
end
