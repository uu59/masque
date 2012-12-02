# -- coding: utf-8

class Masque
  module DSL
    def save_screenshot(path)
      page.driver.render(path)
    end
    alias :render :save_screenshot

    def page
      session
    end

    def driver
      session.driver
    end

    def driver_name
      case driver
      when ::Capybara::Driver::Webkit, ::Capybara::Webkit::Driver
        :webkit
      when ::Capybara::Poltergeist::Driver
        :poltergeist
      else
        :unknown
      end
    end

    def set_headers(headers = {})
      case driver_name
      when :webkit
        headers.each_pair {|k,v| driver.header(k, v)}
      when :poltergeist
        driver.headers = headers
      else
        raise "for unknown driver"
      end
    end
    alias :set_request_headers :set_headers

    def cookies
      driver.cookies # driver specific format
    end

    def resize(x, y)
      case driver_name
      when :webkit
        driver.resize_window(x, y)
      when :poltergeist
        driver.resize(x, y)
      else
        raise "for unknown driver"
      end
    end
    alias :resize_window :resize

  end
end
