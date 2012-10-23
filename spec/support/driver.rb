# -- coding: utf-8

require "spec_helper"

shared_examples_for "driver" do
  let!(:masque) do
    m = Masque.new(:driver => driver)
    m.agent.session = Capybara::Session.new(driver, Dummy)
    m
  end

  describe ".run" do
    it "Capybara::DSL ready" do
      mods = []
      title = nil
      masque.run do
        visit "/dummy"
        title = evaluate_script "document.title"
        within("#form") do
          fill_in "a", :with => "A"
        end
        find('input[type="submit"]').click
      end
      title["dummy"].should_not be_nil
    end

    it "#save_screenshot" do
      path = "spec/tmp.png"
      masque.run do
        visit "/"
        render(path)
      end
      File.file?(path).should be_true
      File.size(path).should be > 0
      File.unlink(path)
    end

    it "#cookies" do
      cookie = masque.run do
        visit "/"
        cookies["rack.session"]
      end
      cookie.should_not be_nil
    end

    it "#set_headers" do
      masque.run do
        set_headers({"User-Agent" => "rspec"})
        visit "/"
        find('#ua').text.should == "rspec"
      end
    end

    it "#resize" do
      masque.run do
        resize(400, 300)
        visit "/"
        size = MultiJson.load(find('#js').text)
        size["w"].should == 400
        size["h"].should == 300
      end
    end

    it "return last evaluated value" do
      body = masque.run do
        visit "/"
        page.body
      end
      body.should_not be_nil
    end
  end

  it "#reset_session!" do
    first, second, third = nil

    masque.run do
      visit "/"
      first = find('h1').text.to_i
    end
    masque.run do
      visit "/"
      second = find('h1').text.to_i
    end

    masque.reset_session!
    masque.run do
      visit "/"
      third = find('h1').text.to_i
    end

    first.should == 1
    second.should == 2
    third.should == 1
  end
end
