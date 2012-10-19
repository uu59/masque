require "capybara"
require "capybara/dsl"
require "capybara/webkit"
require 'capybara/poltergeist'
require "headless"
require "masque/version"
require "masque/dsl"

class Masque
  attr_reader :options, :agent

  def self.run(options = {}, &block)
    new(options).run(&block)
  end

  def initialize(options = {})
    @options = options
    @agent = Class.new do
      include Capybara::DSL
      include Masque::DSL
    end.new
  end

  def reset_session!
    run do
      driver = page.driver
      driver.reset!
    end
  end

  def run(&block)
    case options[:driver]
    when :poltergeist
      Capybara.using_driver(:poltergeist) do
        @agent.instance_eval(&block)
      end

    when :webkit, nil
      h = Headless.new(options)
      h.start
      ObjectSpace.define_finalizer(@agent) do
        h.destroy
      end
      Capybara.using_driver(:webkit) do
        @agent.instance_eval(&block)
      end
    end
  end
end
