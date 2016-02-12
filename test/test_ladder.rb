require 'minitest/autorun'

require 'ocean_shores/ladder'

class TestLadder < Minitest::Test
  def test_empty_ladder
    empty_ladder = Ladder.new
    assert_empty empty_ladder.players
  end

  def test_empty_ladder_new_players
    empty_ladder = Ladder.new
    ladder = empty_ladder.add_match(winner: 123, loser: 456)
    assert_empty empty_ladder.players
    assert_equal [123, 456], ladder.players
  end
end
