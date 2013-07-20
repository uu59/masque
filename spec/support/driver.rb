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

    describe "#wait_until" do
      it "return block value" do
        masque.run do
          wait_until do
            "hi"
          end.should == "hi"
        end
      end

      it "raise TimeoutError when timeout" do
        expect do
          masque.run do
            wait_until(0.01) do
            end
          end
        end.to raise_error(TimeoutError)
      end
    end

    describe "compat" do
      context "2.0.x with compat_capybara_20!" do
        before do
          masque.compat_capybara_20!
        end

        context "config.match = :one" do
          it "raise error multiple elements found" do
            expect do
              masque.run do
                visit "/"
                find "div"
              end
            end.to raise_error(Capybara::Ambiguous)
          end
        end

        context "config.exact_options = true" do
          it "don't find ambiguous text matching" do
            expect do
              masque.run do
                visit "/"
                page.select "1", :from => "numbers"
              end
            end.to raise_error(Capybara::ElementNotFound)
          end
        end

        context "config.ignore_hidden_elements = true" do
          it "don't find hidden element" do
            expect do
              masque.run do
                visit "/dummy"
                find "title", :text => "hi dummy"
              end
            end.to raise_error(Capybara::ElementNotFound)
          end
        end

        context "config.visible_text_only = true" do
          it do
            pending "capybara-webkit 1.0.0 can't handle correctly" if driver == :webkit

            masque.run do
              visit "/"
              find("#hide-text").text.should == ""
            end
          end
        end
      end

      context "1.x with compat_capybara_1x!" do
        before do
          masque.compat_capybara_1x!
        end

        context "config.match = :prefer_exact" do
          it "don't raise error multiple elements found" do
            expect do
              masque.run do
                visit "/"
                find "div"
              end
            end.to_not raise_error
          end
        end

        context "config.ignore_hidden_elements = false" do
          it "can find hidden element" do
            expect do
              masque.run do
                visit "/dummy"
                find "title", :text => "hi dummy"
              end
            end.to_not raise_error
          end
        end

      end
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
