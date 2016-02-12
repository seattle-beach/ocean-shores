module OceanShores
  class Ladder
    attr_reader :players

    def initialize(players=[])
      @players = players.dup.freeze
    end

    def add_match(winner:, loser:)
      new_players = @players.dup
      winner_position = new_players.index(winner)
      loser_position = new_players.index(loser)
      if winner_position && loser_position
        if winner_position < loser_position
          return Ladder.new(new_players)
        elsif winner_position - loser_position == 1
          new_players[winner_position] = loser
          new_players[loser_position] = winner
          return Ladder.new(new_players)
        end
      elsif !winner_position && !loser_position
        new_players << winner
        new_players << loser
      elsif !winner_position && loser_position
        total_ladder_length = new_players.size
        distance_between_loser_and_end = total_ladder_length - loser_position
        place_to_add_winner = total_ladder_length - (distance_between_loser_and_end / 2).to_i
        new_players = new_players.insert(place_to_add_winner, winner)
        return Ladder.new(new_players)
      elsif winner_position && !loser_position
        return Ladder.new(new_players << loser)
      end
      Ladder.new(new_players)
    end
  end
end
