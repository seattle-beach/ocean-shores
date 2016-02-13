require 'sinatra/base'
require 'sinatra/json'
require 'tilt/erb'

require_relative 'db'
require_relative 'ladder'
require_relative 'models'

module OceanShores
  class App < Sinatra::Base
    get '/' do
      ladder = Models::Match.all.inject(Ladder.new) do |ladder, match|
        ladder.add_match(winner: match.teams[0].players[0].id,
                         loser: match.teams[1].players[0].id)
      end
      players = Models::Player.all.sort_by { |player| ladder.players.index(player.id) }

      erb :index, locals: { players: players }
    end

    post '/matches' do
      DB.transaction do
        match = Models::Match.create

        params.group_by { |k, v| k.split('-').first }
              .sort_by { |t, _| t.sub(/^t/, '').to_i }
              .each.with_index do |(team, players), index|
          team = Models::Team.create(rank: index + 1)
          players.map(&:last).each do |name|
            player = Models::Player.find_or_create(name: name)
            team.add_player(player)
          end
          match.add_team(team)
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
