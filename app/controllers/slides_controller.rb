class SlidesController < ApplicationController
  before_action :set_target, only: [:edit, :create]
  before_action :set_performances, only: [:edit, :create]

  def edit
  end

  def create
    @performances.each_with_index do |performance, i|
      performance.value = create_params['performance_value']["#{i}"]
      performance.content = ''
    end
    @target.update(value: create_params['target_value'])
    redirect_to root_url, notice: '保存しました。'
  end

  private

  def start_on
    Date.today.beginning_of_month
  end

  def set_performances
    if @target.persisted?
      @performances = @target.performances
    else
      beginning_of_business_day = beginning_of_business_day(start_on)
      @performances = Array.new(business_weeks(start_on)) do |n|
        @target.performances.build(start_on: beginning_of_business_day + 7.days * n)
      end
    end
  end

  def set_target
    @target = Target.find_or_initialize_by(
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

  def create_params
    params.permit(:target_value, performance_value: {})
  end
end
