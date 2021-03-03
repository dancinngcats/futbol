require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative 'csv_loadable'
require_relative './games_manager'
require_relative './teams_manager'
require_relative './game_teams_manager'

class StatTracker

  include Mathable

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(game_teams_path, game_path, teams_path, csv_loadable = CsvLoadable.new)
    @games      = csv_loadable.load_csv_data(game_path, Game)
    @teams      = csv_loadable.load_csv_data(teams_path, Team)
    @game_teams = csv_loadable.load_csv_data(game_teams_path, GameTeam)
  end

  def self.from_csv(locations)
    game_teams_path = locations[:game_teams]
    games_path      = locations[:games]
    teams_path      = locations[:teams]
    new(game_teams_path, games_path, teams_path)
  end

  def highest_total_score
    games_manager = GamesManager.new(self).highest_total_score
  end

  def lowest_total_score
    games_manager = GamesManager.new(self).lowest_total_score
  end

  def percentage_home_wins
    game_teams_manager = GameTeamsManager.new(self).percentage_home_wins
  end

  def percentage_visitor_wins
    game_teams_manager = GameTeamsManager.new(self).percentage_visitor_wins
  end

  def percentage_ties
    game_teams_manager = GameTeamsManager.new(self).percentage_ties
  end

  def count_of_games_by_season
    games_manager = GamesManager.new(self).count_of_games_by_season
  end

  def average_goals_per_game
    games_manager = GamesManager.new(self).average_goals_per_game
  end

  def average_goals_by_season
    games_manager = GamesManager.new(self).average_goals_by_season
  end

  def count_of_teams
    teams_manager = TeamsManager.new(self).count_of_teams
  end

  def best_offense
    game_teams_manager = GameTeamsManager.new(self).best_offense
  end

  def worst_offense
    game_teams_manager = GameTeamsManager.new(self).worst_offense
  end

  def highest_scoring_visitor
    game_teams_manager = GameTeamsManager.new(self).highest_scoring_visitor
  end

  def lowest_scoring_visitor
    game_teams_manager = GameTeamsManager.new(self).lowest_scoring_visitor
  end

  def highest_scoring_home_team
    game_teams_manager = GameTeamsManager.new(self).highest_scoring_home_team
  end

  def lowest_scoring_home_team
    game_teams_manager = GameTeamsManager.new(self).lowest_scoring_home_team
  end

  def most_tackles(season_id)
    game_teams_manager = GameTeamsManager.new(self).most_tackles(season_id)
  end

  def fewest_tackles(season_id)
    game_teams_manager = GameTeamsManager.new(self).fewest_tackles(season_id)
  end

  #Team Statistics
  def team_info(team_id)
    teams_manager = TeamsManager.new(self).team_info(team_id)
  end

  def rival(team_id)
    game_ids_hash = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      game_ids_hash[team_id] << game_team.game_id if game_team.team_id == team_id
    end

    all_the_teams_that_team_id_has_played = []
    @game_teams.each do |game_team|
      if game_team.team_id == team_id
        next
      elsif game_ids_hash[team_id].include?(game_team.game_id)
        all_the_teams_that_team_id_has_played << game_team
      end
    end

    all_opponents_game_by_id = all_the_teams_that_team_id_has_played.group_by do |game_team|
      game_team.team_id
    end

    length = all_opponents_game_by_id.map do |id, game|
      game.length
    end

    a = all_opponents_game_by_id.each do |keys, values|
      all_opponents_game_by_id[keys] = values.map { |v|
        if v.result == "WIN"
           1
         elsif v.result == "LOSS"
           0
         elsif v.result == "TIE"
           0
        end
      }
    end

    b = a.each do |keys, values|
      all_opponents_game_by_id[keys] = (values.sum.to_f / values.count.to_f )
    end

    c = b.max_by do |keys, values|
      values
    end

    team = @teams.find do |team|
      team.team_id == c.first
    end
    team.teamname

  end

  def favorite_opponent(team_id)
    game_ids_hash = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      game_ids_hash[team_id] << game_team.game_id if game_team.team_id == team_id
    end

    all_the_teams_that_team_id_has_played = []
    @game_teams.each do |game_team|
      if game_team.team_id == team_id
        next
      elsif game_ids_hash[team_id].include?(game_team.game_id)
        all_the_teams_that_team_id_has_played << game_team
      end
    end
    all_opponents_game_by_id = all_the_teams_that_team_id_has_played.group_by do |game_team|
      game_team.team_id
    end

    length = all_opponents_game_by_id.map do |id, game|
      game.length
    end

    opponent_results = all_opponents_game_by_id.each do |keys, values|
      all_opponents_game_by_id[keys] = values.map { |opponent|
        if opponent.result == "WIN"
           0
         elsif opponent.result == "LOSS"
           1
         elsif opponent.result == "TIE"
           0
        end
      }
    end

    opponent_loss_percent = opponent_results.each do |keys, values|
      all_opponents_game_by_id[keys] = (values.sum.to_f / values.count.to_f )
    end

    favorite_opponent = opponent_loss_percent.max_by do |keys, values|
      values
    end

    team = @teams.find do |team|
      team.team_id == favorite_opponent.first
    end
    team.teamname

  end


  def loss_percentage(team1, team2)
    (team1.losses / total_games ).round(2)

  end

  def average_win_percentage(team_id)
    all_games = @game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end
    wins = 0.0
    losses = 0.0
    ties = 0.0
    all_games.each do |game|
      wins += 1.0 if game.result == "WIN"
      losses += 1.0 if game.result == "LOSS"
      ties += 1 if game.result == "TIE"
    end
    avg_win_percent = (wins / (wins + losses + ties)).round(2)
  end

  def best_season(team_id)
    result = win_percent_by_season(team_id)
    result.max_by {|season, win_percent| win_percent}.first.to_s
  end

  def worst_season(team_id)
    result = win_percent_by_season(team_id)
    result.min_by {|season, win_percent| win_percent}.first.to_s
  end

  def win_percent_by_season(team_id)
    season_hash = {}
    season_and_games(team_id).each do |season, game_seasons|
      matching_game_ids = game_seasons.map(&:game_id)
      matching_game_teams = @game_teams.find_all do |game_team|
        game_team.team_id == team_id && matching_game_ids.include?(game_team.game_id)
      end
      season_hash[season] = percentage(matching_game_teams, "WIN")
    end
    season_hash
  end

  def season_and_games(team_id)
    @games.find_all do |game|
      game.away_team_id == team_id|| game.home_team_id == team_id
    end.group_by(&:season)
  end

  def percentage(matching_game_teams, condition)
    win_count = matching_game_teams.count do |season_game|
      season_game.result == condition
    end
    (win_count / matching_game_teams.length.to_f).round(2)
  end

  def most_goals_scored(team_id)
    find_team_games_played(team_id).max_by(&:goals).goals
  end

  def games_by_season(season_id)
    season_games = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      season_games[season_id] << game_team if game_team.game_id[0..3] == season_id[0..3]
    end
    season_games
  end

  def most_accurate_team(season_id)
    game_teams = games_by_season(season_id)
    shot_goal = Hash.new { |hash, key| hash[key] = [] }
    game_teams[season_id].each do |game_team|
      shot_goal[game_team.team_id] << game_team.shot_goal_ratio
    end
    shot_goal.each do |team, ratio|
      shot_goal[team] = ratio.sum / ratio.length
    end
    shot_goal.delete("29")
    team_ratio = shot_goal.max_by do |team, avg|
      avg
    end
    team_name = @teams.find do |team|
      team_ratio.first == team.team_id
    end
    team_name.teamname
  end

  def least_accurate_team(season_id)
    game_teams = games_by_season(season_id)
    shot_goal = Hash.new { |hash, key| hash[key] = [] }
    game_teams[season_id].each do |game_team|
      shot_goal[game_team.team_id] << game_team.shot_goal_ratio
    end
    shot_goal.each do |team, ratio|
      shot_goal[team] = ratio.sum / ratio.length
    end
    team_ratio = shot_goal.min_by do |team, avg|
      avg
    end
    team_name = @teams.find do |team|
      team_ratio.first == team.team_id
    end
    team_name.teamname
  end


  def winningest_coach(season_id)
    winners = []
    season = Hash.new { |hash, key| hash[key] = [] }
    @games.each do |game|
      season[game.season] << game.game_id
    end
    teams_that_won = season[season_id].find_all do |game_id|
      winners << @game_teams.find do |teams|
        teams.game_id == game_id && teams.result == "WIN"
      end
    end
    winners = winners.compact
    coaches = winners.map { |winner| winner.head_coach }
    coach_count = Hash.new(0)
    coaches.each { |coach| coach_count[coach] += 1 }
    coach_count.sort_by { |coach, number| number }.last[0]
  end

  def worst_coach(season_id)
    winners = []
    season = Hash.new { |hash, key| hash[key] = [] }
    @games.each do |game|
      season[game.season] << game.game_id
    end
    teams_that_won = season[season_id].find_all do |game_id|
      winners << @game_teams.find do |teams|
        teams.game_id == game_id && teams.result == "LOSS"
      end
    end
    winners = winners.compact
    coaches = winners.map { |winner| winner.head_coach }
    coach_count = Hash.new(0)
    coaches.each { |coach| coach_count[coach] += 1 }
    coach_count.sort_by { |coach, number| number }.first[0]
  end

  def fewest_goals_scored(team_id)
    find_team_games_played(team_id).min_by(&:goals).goals
  end

  def find_team_games_played(team_id)
    @game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end
  end
end
