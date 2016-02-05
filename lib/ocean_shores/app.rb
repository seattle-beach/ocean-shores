require 'sinatra/base'
require 'tilt/erb'

require_relative 'db'

module OceanShores
  class App < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/matches' do
      DB.transaction do
        team_ids = []
        params
          .group_by { |k, v| k.split('-').first }
          .sort_by(&:first)
          .each do |team, players|

          team_id = DB[:teams].insert

          player_names = players.map(&:last)
          player_names.each do |name|
            player = DB[:players][name: name]
            player_id = player ? player['id'] : DB[:players].insert(name: name)
            DB[:players_teams].insert(player_id: player_id, team_id: team_id)
          end

          team_ids << team_id
        end

        match_id = DB[:matches].insert
        team_ids.each.with_index do |team_id, index|
          rank = index + 1
          DB[:matches_teams].insert(rank: rank, match_id: match_id, team_id: team_id)
        end
      end

      redirect '/'
    end

    run! if app_file == $0
  end
end
