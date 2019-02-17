class TeamsController < ApplicationController
  def index
    teams = Team.order(:order)
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

  def edit
    @team = Team.find(params[:id])
  end

  def update
    team = Team.find(params[:id])
    team.update(team_params)
    flash[:notice] = "チーム更新が成功しました！"
    redirect_to root_url
  end

  def destroy
    team = Team.find(params[:id])
    team.destroy
    flash[:notice] = "#{team.name}を削除しました！"
    redirect_to root_url
  end

  private

  def team_params
    params.require(:team).permit(:name, :order, :enabled)
  end
end
