require 'minitest/autorun'
require 'capybara'
require 'capybara/dsl'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

ENV['DATABASE_URL'] = 'sqlite::memory:'
require 'ocean_shores/db'
Sequel.extension :migration
Sequel::Migrator.run(OceanShores::DB, File.expand_path('../../db/migrations', __FILE__))

require 'ocean_shores/app'
include OceanShores

Capybara.app = App

class TestApp < Minitest::Test
  include Capybara::DSL

  def test_app
    visit '/'

    assert_equal 200, page.status_code
  end

  def test_add_match
    assert_equal 0, DB[:matches].count
    assert_equal 0, DB[:teams].count
    assert_equal 0, DB[:players].count

    visit '/'
    fill_in 't1-p1', :with => 'Alpha Chen'
    fill_in 't2-p1', :with => 'Augustus Lidaka'
    click_button 'Add Match'

    assert_equal 200, page.status_code

    assert_equal 1, DB[:matches].count
    assert_equal 2, DB[:teams].count
    assert_equal 2, DB[:players].count
  end

  def run(*args, &block)
    DB.transaction(rollback: :always, auto_savepoint: true) do
      super
    end
  end
end
