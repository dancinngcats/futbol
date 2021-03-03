class TeamsManager
  def initialize(data)
    @teams = data.teams
  end

  def count_of_teams
    counter = 0
    @teams.each do |team|
      counter += 1
    end
    counter
  end

  def get_team_name(team_data)
     @teams.find do |team|
      if team.team_id == team_data[0]
        return team.teamname.to_s
      end
    end
  end

end
