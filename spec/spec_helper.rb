# -- coding: utf-8

require "pp"
require "rubygems"
require "rspec-expectations"
require "rspec/matchers/built_in/be"
require File.expand_path("../support/app.rb", __FILE__)

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start
end

require File.expand_path("../../lib/masque.rb", __FILE__)


RSpec.configure do |config|
  Capybara.app = Dummy
end
