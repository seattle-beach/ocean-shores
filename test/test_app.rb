require 'logger'

require 'minitest/autorun'
require 'capybara'
require 'capybara/dsl'
require 'capybara-select2'

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
  include Capybara::Select2
  include Rack::Test::Methods

  def test_add_match
    post '/matches', 't1-p1' => 'Alpha Chen', 't2-p1' => 'Augustus Lidaka'

    assert_equal 1, Models::Match.count
    assert_equal 2, Models::Team.count
    assert_equal 2, Models::Player.count
  end

  def test_add_existing_player
    Models::Player.create(name: 'Alpha Chen')

    post '/matches', 't1-p1' => 'Alpha Chen', 't2-p1' => 'Augustus Lidaka'

    assert_equal 1, Models::Match.count
    assert_equal 2, Models::Team.count
    assert_equal 2, Models::Player.count
  end

  def test_players_api
    Models::Player.import([:name], ['Alpha Chen', 'Augustus Lidaka'])

    visit '/player_names.json'

    assert_equal 200, page.status_code
    assert_equal 'application/json', page.response_headers['Content-Type']

    player_names = JSON.load(page.body)
    assert_equal ['Alpha Chen', 'Augustus Lidaka'], player_names
  end

  def app
    App
  end

  def run(*args, &block)
    assert_equal 0, Models::Match.count
    assert_equal 0, Models::Team.count
    assert_equal 0, Models::Player.count

    DB.transaction(rollback: :always, auto_savepoint: true) do
      super
    end
  end
end
