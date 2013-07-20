# -- coding: utf-8

require "spec_helper"

describe Masque do
  describe ".new" do
    it do
      opts = {:display => 50, :driver => :webkit}
      masque = Masque.new(opts)
      masque.options.should == opts
      masque.respond_to?(:run).should be_true
    end

    describe "compat_mode" do
      subject { Masque.new(:capybara_compat => ver).compat_mode }

      context "2.1" do
        let(:method) { :compat_capybara_21! }
        let(:ver) { "2.1" }
        it { should == ver }
      end

      context "2.0" do
        let(:method) { :compat_capybara_20! }
        let(:ver) { "2.0" }
        it { should == ver }
      end

      context "1.x" do
        let(:method) { :compat_capybara_1x! }
        let(:ver) { "1.x" }
        it { should == ver }
      end
    end

    it "default compat mode is 1.x" do
      Masque.any_instance.should_receive(:compat_capybara_1x!)
      Masque.new
    end
  end
end

