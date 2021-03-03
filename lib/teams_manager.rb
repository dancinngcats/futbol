class TeamsManager
  def initialize(data)
    @teams = data.teams
  end

  def team_info(team_id)
    team = @teams.find { |team| team.team_id == team_id }

    {
      "team_id"      => team.team_id,
      "franchise_id" => team.franchiseid,
      "team_name"    => team.teamname,
      "abbreviation" => team.abbreviation,
      "link"         => team.link
    }
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
