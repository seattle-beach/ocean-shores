require 'sequel'

module OceanShores
  module Models
    class Match < Sequel::Model
      one_to_many :teams
      many_to_many :players, join_table: :teams, right_key: :id, right_primary_key: :team_id
    end

    class Team < Sequel::Model
      many_to_one :match
      many_to_many :players
    end

    class Player < Sequel::Model
      many_to_many :team
      many_to_many :matches, join_table: :teams,
                   left_key: :id, left_primary_key: :team_id, right_key: :match_id
    end
  end
end
