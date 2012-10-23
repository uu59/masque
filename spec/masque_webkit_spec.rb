# -- coding: utf-8

require "spec_helper"

describe Masque do
  let(:driver) { :webkit }

  context "webkit" do
    it_behaves_like "driver"
  end
end

