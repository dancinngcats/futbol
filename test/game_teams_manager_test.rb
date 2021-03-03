require_relative 'test_helper'
require_relative '../lib/helpable'
require 'mocha/minitest'

class GameTeamsManagerTest < Minitest::Test
  include Helpable

  def test_it_exists
    game_teams_manager = GameTeamsManager.new(setup)

    assert_instance_of GameTeamsManager, game_teams_manager
  end

  def test_percentage_home_wins
    game_teams_manager = GameTeamsManager.new(setup)

    assert_equal 0.57, game_teams_manager.percentage_home_wins
  end

  def test_percentage_visitor_wins
    game_teams_manager = GameTeamsManager.new(setup)

    assert_equal 0.36, game_teams_manager.percentage_visitor_wins
  end

  def test_percentage_ties
    game_teams_manager = GameTeamsManager.new(setup)

    assert_equal 0.04, game_teams_manager.percentage_ties
  end

  def test_best_offense
    game_teams_manager = GameTeamsManager.new(setup)

    assert_equal "FC Dallas", game_teams_manager.best_offense
  end

  def test_worst_offense
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "Seattle Sounders FC", game_teams_manager.worst_offense
  end

  def test_highest_scoring_visitor
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "FC Dallas", game_teams_manager.highest_scoring_visitor
  end

  def test_lowest_scoring_visitor
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "Seattle Sounders FC", game_teams_manager.lowest_scoring_visitor
  end

  def test_highest_scoring_home_team
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "LA Galaxy", game_teams_manager.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "Sporting Kansas City", game_teams_manager.lowest_scoring_home_team
  end

  def test_most_tackles_by_team_in_season
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "FC Dallas", game_teams_manager.most_tackles("20122013")
  end

  def test_fewest_tackles_by_team_in_season
    game_teams_manager = GameTeamsManager.new(setup)
    assert_equal "New York Red Bulls", game_teams_manager.fewest_tackles("20122013")
  end

  def calculate_average_scores
    NEEDS TO BE MOCKED AND STUBBED
  end

end
