# -- coding: utf-8

require "spec_helper"

describe Masque do
  [:webkit, :poltergeist].each do |driver|
    context "Using #{driver} driver" do
      let(:driver) { driver }
      let!(:masque) { Masque.new(:driver => driver) }

      it ".new" do
        opts = {:display => 50, :driver => driver}
        masque = Masque.new(opts)
        masque.options.should == opts
        masque.respond_to?(:run).should be_true
      end

      describe ".run" do
        it "Capybara::DSL ready" do
          mods = []
          title = nil
          masque.run do
            mods = self.class.included_modules
            visit "/dummy"
            title = evaluate_script "document.title"
          end
          mods.include?(Capybara::DSL).should be_true
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

        it "return last evaluated value" do
          body = masque.run do
            visit "/"
            page.body
          end
          body.should_not be_nil
        end
      end

      it "#reset_session!" do
        masque.reset_session!
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
  end
end

