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
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Population vs GDP For 5 Big Countries [2009]")
      f.xAxis(categories: ["3/04 から 03/10", "03/11 から 03/17", "03/18 から 03/24", "03/25 から 03/31"])
      f.series(yAxis: 0, stacking: 'normal', name: "1", data: [100, 100, 100, 100] )
      f.series(yAxis: 0, stacking: 'normal', name: "2", data: [nil, 100, 100, 100] )
      f.series(yAxis: 0, stacking: 'normal', name: "3", data: [nil, nil, 100, 100] )
      f.series(yAxis: 0, stacking: 'normal', name: "4", data: [nil, nil, nil, 100] )
      f.series(name: "目標", data: [[0, 1000], [3, 1000]], type: 'line')

      f.yAxis [
        {title: {text: "GDP in Billions", margin: 70} },
        {title: {text: "Population in Millions"}, opposite: true},
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 2,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
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
