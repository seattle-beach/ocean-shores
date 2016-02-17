require 'sequel'

Sequel::Model.plugin :timestamps, update_on_create: true

module OceanShores
  module Models
    class Match < Sequel::Model
      one_to_many :teams
    end

    class Team < Sequel::Model
      many_to_one :match
      many_to_many :players
    end

    class Player < Sequel::Model
      many_to_many :team
    end
  end
end
