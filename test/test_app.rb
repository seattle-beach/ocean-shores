require 'minitest/autorun'
require 'capybara'
require 'capybara/dsl'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'ocean_shores/app'
include OceanShores

Capybara.app = App

class TestApp < Minitest::Test
  include Capybara::DSL

  def test_app
    visit '/'

    assert_equal 200, page.status_code
  end
end
