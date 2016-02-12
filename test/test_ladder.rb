require_relative 'test_helper'

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

  def test_only_two_players
    ladder = Ladder.new([123, 456])
    assert_equal [123, 456], ladder.add_match(winner: 123, loser: 456).players
    assert_equal [456, 123], ladder.add_match(winner: 456, loser: 123).players
  end

  def test_only_two_players_one_new_player
    ladder = Ladder.new([123, 456])

    assert_equal [123, 789, 456], ladder.add_match(winner: 789, loser: 123).players
    assert_equal [123, 456, 789], ladder.add_match(winner: 789, loser: 456).players
    assert_equal [123, 456, 789], ladder.add_match(winner: 123, loser: 789).players
    assert_equal [123, 456, 789], ladder.add_match(winner: 456, loser: 789).players
  end
end
