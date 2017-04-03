require_relative '../lib/bloc_works.rb'
require 'test/unit'
require 'rack/test'

class BlocWorksTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application.new
  end

  test "it should be hooked up properly" do
    get "/" 
    assert last_response.ok?
    assert last_response.body.include?("Hello Blocheads!")
    assert_equal "Hello Blocheads!", last_response.body
  end

end