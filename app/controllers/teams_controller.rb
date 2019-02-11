class TeamsController < ApplicationController
  def index
    teams = Team.all
    @enabled_teams = teams.enabled
    @disabled_teams = teams.disabled
  end
end
