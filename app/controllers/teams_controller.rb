class TeamsController < ApplicationController
  def index
    teams = Team.all
    @enabled_teams = teams.enabled
    @disabled_teams = teams.disabled
  end

  def new
  end

  def create
    Team.create(team_params)
    flash[:notice] = "チーム作成が成功しました！"
    redirect_to root_url
  end

  private

  def team_params
    params.require(:team).permit(:name, :order)
  end
end
