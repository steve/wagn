require_relative '../profile_test_helper'

describe "Topic", ActionController::IntegrationTest do
  include RubyProf::Test
  
  it "topic" do
    get '/Arts_education'
  end
end