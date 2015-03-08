require_relative '../../test_helper'

describe FrontendRescue do
  it "must be defined" do
    FrontendRescue::VERSION.wont_be_nil
  end
end
