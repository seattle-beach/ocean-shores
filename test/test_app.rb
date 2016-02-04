require 'minitest/autorun'
require 'rack/test'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'ocean_shores/app'
include OceanShores

class TestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_app
    get '/'

    assert last_response.ok?
  end
end
