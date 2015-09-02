# -*- encoding : utf-8 -*-
require "spec_helper"

describe TimeHelper do
  it "convert datestamp to javascript date" do
    expect(TimeHelper.datestamp_to_js(19700101)).to eq(0)
  end

  it "convert datestamp to human readable string" do
    expect(TimeHelper.datestamp_to_string(19700101)).to eq("1970-01-01")
  end
end
