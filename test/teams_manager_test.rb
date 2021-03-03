require_relative 'test_helper'
require_relative '../lib/helpable'
require 'mocha/minitest'

class TeamsManagerTest < Minitest::Test
  include Helpable

  def test_it_exists
    teams_manager = TeamsManager.new(setup)

    assert_instance_of TeamsManager, teams_manager
  end

  def test_it_counts_teams
    teams_manager = TeamsManager.new(setup)
    assert_equal 32, teams_manager.count_of_teams
  end

  def test_it_can_get_team_info
    teams_manager = TeamsManager.new(setup)
    expected = {"team_id"=>"3",
                "franchise_id"=>"10",
                "team_name"=>"Houston Dynamo",
                "abbreviation"=>"HOU",
                "link"=>"/api/v1/teams/3"
              }
    assert_equal expected, teams_manager.team_info("3")
  end
end
