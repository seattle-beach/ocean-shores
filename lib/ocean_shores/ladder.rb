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

      winner_position = new_players.index(winner)
      loser_position = new_players.index(loser)

      return Ladder.new(new_players) if winner_position < loser_position

      new_players.delete(winner)
      new_players.insert(self._place_to_add_winner(loser_position, winner_position), winner)

      Ladder.new(new_players)
    end

    def _place_to_add_winner(loser_position, winner_position)
      distance = winner_position - loser_position
      return loser_position if distance == 1

      new_distance = (distance / 2.0).to_i
      winner_position - new_distance
    end
  end
end
