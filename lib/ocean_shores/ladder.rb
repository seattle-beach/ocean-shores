module OceanShores
  class Ladder
    attr_reader :players

    def initialize(players=[])
      @players = players.dup.freeze
    end

    def add_match(winner:, loser:)
      new_players = @players.dup
      new_players << winner
      new_players << loser
      Ladder.new(new_players)
    end
  end
end
