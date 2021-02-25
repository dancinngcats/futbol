require_relative 'test_helper'

class StatTrackerTest < Minitest::Test

  def setup
    @locations = {
      games: './data/games_truncated.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams_truncated.csv'
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_counts_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end
end
