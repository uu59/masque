# -- coding: utf-8

class Masque
  module DSL
    def save_screenshot(path)
      page.driver.render(path)
    end
    alias :render :save_screenshot
  end
end
