module OceanShores
  class Ladder
    attr_reader :players

    def initialize(players=[])
      @players = players.dup.freeze
    end

    def add_match(winner:, loser:)
      new_players = @players.dup

      new_players << winner unless self.players.include?(winner)
      new_players << loser unless self.players.include?(loser)

      winner_index = new_players.index(winner)
      loser_index = new_players.index(loser)
      return Ladder.new(new_players) if winner_index < loser_index

      diff = (winner_index - loser_index) / 2
      new_index = winner_index - [diff, 1].max
      new_players.delete(winner)
      new_players.insert(new_index, winner)

      Ladder.new(new_players)
    end
  end
end
