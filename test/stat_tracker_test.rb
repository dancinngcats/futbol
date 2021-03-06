require_relative 'test_helper'
require_relative '../lib/helpable'
require 'mocha/minitest'


class StatTrackerTest < Minitest::Test
  include Helpable

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    @stat_tracker.stubs(:games).returns("Games Array")
    assert_equal "Games Array", @stat_tracker.games
  end

  #Game Statistics Tests

  def test_it_can_find_the_highest_total_score
    assert_equal 6, @stat_tracker.highest_total_score
  end

  def test_percentage_of_two_arrays_lengths
    array1 = ["1", "2", "3"]
    array2 = ["3", "4", "5", "6", "7", "8", "9"]

    assert_equal 0.43, @stat_tracker.arry_percentage(array1, array2)
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 0.57, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    assert_equal 0.04, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    assert_equal ({"20122013"=>49}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_return_average_goals_per_game
    assert_equal 3.92, @stat_tracker.average_goals_per_game
  end


 #League Statistics Tests

  def test_it_counts_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_best_offense
    assert_equal "FC Dallas", @stat_tracker.best_offense
  end

  def test_worst_offense
    assert_equal "Seattle Sounders FC", @stat_tracker.worst_offense
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "LA Galaxy", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "Seattle Sounders FC", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Sporting Kansas City", @stat_tracker.lowest_scoring_home_team
  end


  #Season Statistics Tests

  def test_winningest_coach_best_win_percentage_for_season
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20122013")
  end

  def test_worst_coach
    assert_equal "Mike Babcock", @stat_tracker.worst_coach("20122013")
  end

  def test_most_tackles_by_team_in_season
    assert_equal "FC Dallas", @stat_tracker.most_tackles("20122013")
  end

  def test_fewest_tackles_by_team_in_season
    assert_equal "New York Red Bulls", @stat_tracker.fewest_tackles("20122013")
  end

  def test_best_season

    assert_equal "20122013", @stat_tracker.best_season("8")
  end

  def test_worst_season

    assert_equal "20122013", @stat_tracker.worst_season("8")
  end

  def test_most_goals_scored

    assert_equal 3, @stat_tracker.most_goals_scored("3")
  end

  def test_fewest_goals_scored

    assert_equal 1, @stat_tracker.fewest_goals_scored("3")
  end

  #Team Statistics Tests
  def test_it_can_get_team_info
    expected = {"team_id"=>"3",
                "franchise_id"=>"10",
                "team_name"=>"Houston Dynamo",
                "abbreviation"=>"HOU",
                "link"=>"/api/v1/teams/3"
              }
    assert_equal expected, @stat_tracker.team_info("3")
  end

  def test_it_can_find_teams_rival
    assert_equal "FC Dallas", @stat_tracker.rival("3")
  end

  def test_it_can_find_teams_fav_opponent
    assert_equal "Houston Dynamo", @stat_tracker.favorite_opponent("6")
  end

  def test_it_can_get_average_win_percentage_for_team_all_games
    assert_equal 0.67, @stat_tracker.average_win_percentage("17")
  end

  def test_it_can_find_most_accurate_team
    assert_equal "FC Dallas", @stat_tracker.most_accurate_team("20122013")
  end

  def test_it_can_find_least_accurate_team
    assert_equal "Seattle Sounders FC", @stat_tracker.least_accurate_team("20122013")
  end

  #Helper Methods

   def test_average_goals_by_season
    assert_equal ({"20122013"=>3.92}), @stat_tracker.average_goals_by_season
   end
end
