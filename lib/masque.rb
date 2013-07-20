require "capybara"
require "capybara/dsl"
require "capybara/webkit"
require 'capybara/poltergeist'
require "headless"
require "masque/version"
require "masque/dsl"

class Masque
  attr_reader :options, :agent, :compat_mode

  def self.run(options = {}, &block)
    new(options).run(&block)
  end

  def initialize(options = {})
    @options = options
    @driver = options[:driver] || :webkit

    case options[:capybara_compat]
    when "2.1"
      compat_capybara_21!
    when "2.0"
      compat_capybara_20!
    when "1.x"
      compat_capybara_1x!
    else # default compat mode is 1.x (currently. IMO this is most useful for crawler, but any use case can be changed this decision)
      compat_capybara_1x!
    end

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

  def compat_capybara_21!
    # https://github.com/jnicklas/capybara/blob/2.1.0/lib/capybara.rb#L323
    @compat_mode = "2.1"
    Capybara.configure do |config|
      config.ignore_hidden_elements = true
      config.match = :smart
      config.exact = false
      config.visible_text_only = false
    end
  end

  def compat_capybara_20!
    # http://www.elabs.se/blog/60-introducing-capybara-2-1
    @compat_mode = "2.0"
    Capybara.configure do |config|
      config.match = :one
      config.exact_options = true
      config.ignore_hidden_elements = true
      config.visible_text_only = true
    end
  end

  def compat_capybara_1x!
    # http://www.elabs.se/blog/60-introducing-capybara-2-1
    @compat_mode = "1.x"
    Capybara.configure do |config|
      config.match = :prefer_exact
      config.ignore_hidden_elements = false
    end
  end
end
