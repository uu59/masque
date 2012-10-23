# -- coding: utf-8

require "spec_helper"

describe Masque do
  let(:driver) { :poltergeist }

  context "poltergeist" do
    it_behaves_like "driver"
  end
end

