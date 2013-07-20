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
    @driver = options[:driver] || :webkit
    @agent = Class.new do
      include Masque::DSL

      attr_accessor :session

      def initialize(session)
        @session = session
      end

      def method_missing(*args, &block)
        if block_given?
          session.__send__(*args, &block)
        else
          session.__send__(*args)
        end
      end
    end.new(Capybara::Session.new(@driver))

    if @driver == :webkit
      h = Headless.new(options.merge(:destroy_at_exit => false, :reuse => true))
      h.start
      ObjectSpace.define_finalizer(@agent.driver.browser.instance_variable_get(:@connection)) do
        h.destroy
      end
    end
  end

  def reset_session!
    run do
      driver.reset!
    end
  end

  def run(&block)
    @agent.instance_eval(&block)
  end

  def compat_capybara_20!
    Capybara.configure do |config|
      config.match = :one
      config.exact_options = true
      config.ignore_hidden_elements = true
      config.visible_text_only = true
    end
  end

  def compat_capybara_1x!
    Capybara.configure do |config|
      config.match = :prefer_exact
      config.ignore_hidden_elements = false
    end
  end
end
