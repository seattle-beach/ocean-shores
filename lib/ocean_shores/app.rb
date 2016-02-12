require 'sinatra/base'
require 'sinatra/json'
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
        sorted = params.group_by { |k, v| k.split('-').first }
                       .sort_by { |t, _| t.sub(/^t/, '').to_i }

        teams = sorted.map do |team, players|
          team = Models::Team.create
          players.map(&:last).each do |name|
            player = Models::Player.find_or_create(name: name)
            team.add_player(player)
          end
          team
        end

        match = Models::Match.create
        teams.each.with_index do |team, index|
          rank = index + 1
          DB[:matches_teams].insert(rank: rank, match_id: match.id, team_id: team.id)
        end
      end

      redirect '/'
    end

    get '/player_names.json' do
      json Models::Player.select_map(:name)
    end

    run! if app_file == $0
  end
end
