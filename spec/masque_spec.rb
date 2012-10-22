# -- coding: utf-8

require "spec_helper"

describe Masque do
  [:webkit, :poltergeist].each do |driver|
    let(:driver) { driver }
    let!(:masque) do
      m = Masque.new(:driver => driver)
      m.agent.session = Capybara::Session.new(driver, Dummy)
      m
    end

    context "Using #{driver} driver" do
      it_behaves_like "driver"
    end
  end
end

