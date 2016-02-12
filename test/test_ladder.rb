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
    assert_equal [123, 789, 456], ladder.add_match(winner: 789, loser: 456).players
    assert_equal [123, 456, 789], ladder.add_match(winner: 123, loser: 789).players
    assert_equal [123, 456, 789], ladder.add_match(winner: 456, loser: 789).players
  end

  def test_adding_a_new_player
    ladder = Ladder.new([1, 2, 3, 4, 5])
    assert_equal [1, 2, 3, 4, 6, 5], ladder.add_match(winner: 6, loser: 5).players
    assert_equal [1, 2, 3, 6, 4, 5], ladder.add_match(winner: 6, loser: 1).players
    assert_equal [1, 2, 3, 6, 4, 5], ladder.add_match(winner: 6, loser: 2).players
  end

  def test_existing_players
    ladder = Ladder.new([1, 2, 3, 4, 5])
    assert_equal [1, 2, 5, 3, 4], ladder.add_match(winner: 5, loser: 1).players
    assert_equal [1, 2, 3, 5, 4], ladder.add_match(winner: 5, loser: 2).players
  end
end
