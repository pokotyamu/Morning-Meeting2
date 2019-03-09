class SlidesController < ApplicationController
  before_action :set_monthly_target, only: [:edit, :update]
  before_action :set_weekly_performances, only: [:edit]

  def edit
  end

  def update
    # TODO: 効率いい方法を考える
    weekly_performance_params.each do |weekly_performance|
      WeeklyPerformance.find(weekly_performance[0]).update(
        value: weekly_performance[1]['value'],
        content: weekly_performance[1]['content']
      )
    end
    @monthly_target.update(value: monthly_target_params['value'])
    redirect_to root_url, notice: '保存しました。'
  end

  def show
    team = Team.find(params[:id])
    @chart = GraphBuilderService.new(team, start_on).build
  end

  private

  def start_on
    Date.today.beginning_of_month
  end

  def set_weekly_performances
    if @monthly_target.weekly_performances.empty?
      beginning_of_business_day = beginning_of_business_day(start_on)
      @weekly_performances = Array.new(business_weeks(start_on)) do |n|
        @monthly_target.weekly_performances.create(start_on: beginning_of_business_day + 7.days * n, content: '')
      end
    else
      @weekly_performances = @monthly_target.weekly_performances.order(:start_on)
    end
  end

  def set_monthly_target
    @monthly_target = MonthlyTarget.find_or_create_by(
      team_id: params[:id],
      start_on: start_on
    )
  end

  def business_weeks(start_on)
    total_day = start_on.end_of_month.day
    case (total_day - 28)
    when 1
      return 5 if start_on.cwday == 1
    when 2
      return 5 if [1, 7].include? (start_on.cwday)
    when 3
      return 5 if [1, 6, 7].include? (start_on.cwday)
    end
    4
  end

  def beginning_of_business_day(start_on)
    start_on.cwday == 1 ? start_on : start_on.next_week.beginning_of_week
  end

  def monthly_target_params
    params.require(:monthly_target).permit(:value)
  end

  def weekly_performance_params
    params.require(:weekly_performance).permit!
  end
end
