require 'sinatra/base'
require 'tilt/erb'

require_relative 'db'
require_relative 'models'

module OceanShores
  class App < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/matches' do
      DB.transaction do
        teams = []
        params
          .group_by { |k, v| k.split('-').first }
          .sort_by(&:first)
          .each do |team, players|

          team = Models::Team.create

          player_names = players.map(&:last)
          player_names.each do |name|
            player = Models::Player.find_or_create(name: name)
            team.add_player(player)
          end

          teams << team
        end

        match = Models::Match.create
        teams.each.with_index do |team, index|
          rank = index + 1
          DB[:matches_teams].insert(rank: rank, match_id: match.id, team_id: team.id)
        end
      end

      redirect '/'
    end

    run! if app_file == $0
  end
end
