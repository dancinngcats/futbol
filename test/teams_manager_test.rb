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
end
