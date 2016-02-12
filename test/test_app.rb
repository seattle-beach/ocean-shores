require 'logger'

require 'minitest/autorun'
require 'capybara'
require 'capybara/dsl'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

ENV['DATABASE_URL'] = 'sqlite::memory:'
require 'ocean_shores/db'
Sequel.extension :migration
Sequel::Migrator.run(OceanShores::DB, File.expand_path('../../db/migrations', __FILE__))
require 'ocean_shores/models'

OceanShores::DB.loggers << Logger.new($STDOUT)

require 'ocean_shores/app'
include OceanShores

Capybara.app = App

class TestApp < Minitest::Test
  include Capybara::DSL

  def test_add_match
    visit '/'
    fill_in 't1-p1', :with => 'Alpha Chen'
    fill_in 't2-p1', :with => 'Augustus Lidaka'
    click_button 'Add Match'

    assert_equal 200, page.status_code

    assert_equal 1, Models::Match.count
    assert_equal 2, Models::Team.count
    assert_equal 2, Models::Player.count
  end

  def test_add_existing_player
    DB[:players].insert(name: 'Alpha Chen')

    visit '/'
    fill_in 't1-p1', :with => 'Alpha Chen'
    fill_in 't2-p1', :with => 'Augustus Lidaka'
    click_button 'Add Match'

    assert_equal 200, page.status_code

    assert_equal 1, Models::Match.count
    assert_equal 2, Models::Team.count
    assert_equal 2, Models::Player.count
  end

  def run(*args, &block)
    assert_equal 0, DB[:matches].count
    assert_equal 0, DB[:teams].count
    assert_equal 0, DB[:players].count

    DB.transaction(rollback: :always, auto_savepoint: true) do
      super
    end
  end
end
