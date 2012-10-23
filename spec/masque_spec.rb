# -- coding: utf-8

require "spec_helper"

describe Masque do
  it ".new" do
    opts = {:display => 50, :driver => :webkit}
    masque = Masque.new(opts)
    masque.options.should == opts
    masque.respond_to?(:run).should be_true
  end
end

