require_relative './stat_tracker'
require_relative 'mathable'

class GameTeamsManager
  include Mathable

  attr_reader :teams

  def initialize(data)
    @game_teams = data.game_teams
    @teams = data.teams
  end

  def percentage_home_wins
    games = @game_teams.find_all do |game_team|
      game_team if game_team.hoa == "home"
    end
    wins = games.find_all do |game|
      game if game.result == "WIN"
    end
    arry_percentage(wins, games)
  end

  def percentage_visitor_wins
    games = @game_teams.find_all do |game_team|
      game_team if game_team.hoa == "away"
    end
    wins = games.find_all do |game|
      game if game.result == "WIN"
    end
    arry_percentage(wins, games)
  end

  def percentage_ties
    games = @game_teams
    ties = @game_teams.find_all do |game|
      game if game.result == "TIE"
    end
    arry_percentage(ties, games)
  end

  def loss_percentage(team1, team2)
    (team1.losses / total_games ).round(2)
  end

  def best_offense
    data = calculate_average_scores
    team_max = data.max_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_max)
  end

  def worst_offense
    data = calculate_average_scores
    team_min = data.min_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_min)
  end

  def highest_scoring_visitor
    data = calculate_home_or_away_average("away")

    team_max = data.max_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_max)
  end

  def lowest_scoring_visitor
    data = calculate_home_or_away_average("away")

    team_min = data.min_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_min)
  end

  def highest_scoring_home_team
    data = calculate_home_or_away_average("home")

    team_max = data.max_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_max)
  end

  def lowest_scoring_home_team
    data = calculate_home_or_away_average("home")

    team_min = data.min_by {|team_id, average_goals| average_goals}
    TeamsManager.new(self).get_team_name(team_min)
  end

  def most_tackles(season_id)
    season_games = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      season_games[season_id] << game_team if game_team.game_id[0..3] == season_id[0..3]
    end

    team_tackles = Hash.new { |hash, key| hash[key] = 0 }
    season_games[season_id].each do |game_team|
      team_tackles[game_team.team_id] += game_team.tackles
    end
    most_tackles = team_tackles.max_by { |team, tackles| tackles }
    TeamsManager.new(self).get_team_name(most_tackles)
  end

  def fewest_tackles(season_id)
    season_games = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      season_games[season_id] << game_team if game_team.game_id[0..3] == season_id[0..3]
    end
    team_tackles = Hash.new { |hash, key| hash[key] = 0 }
    season_games[season_id].each do |game_team|
      team_tackles[game_team.team_id] += game_team.tackles
    end
    fewest_tackles = team_tackles.min_by { |team, tackles| tackles }
    TeamsManager.new(self).get_team_name(fewest_tackles)
  end

  #helper

  def calculate_average_scores
    scores = Hash.new
    @game_teams.each do |game_team|
      if scores[game_team.team_id] == nil
        scores[game_team.team_id] = []
        scores[game_team.team_id] << game_team.goals
      else
        scores[game_team.team_id] << game_team.goals
      end
    end
    data = Hash[scores.map { |team_id, goals| [team_id, (goals.sum.to_f / goals.length.to_f).round(2)]} ]
  end

  def calculate_home_or_away_average(status)
    scores = Hash.new

    @game_teams.each do |game_team|
      if scores[game_team.team_id] == nil && game_team.hoa == status
        scores[game_team.team_id] = []
        scores[game_team.team_id] << game_team.goals
      elsif game_team.hoa == status
        scores[game_team.team_id] << game_team.goals
      end
    end
    data = Hash[scores.map { |team_id, goals| [team_id, (goals.sum.to_f / goals.length.to_f.round(2))]} ]
  end

end
