class GraphBuilderService
  def initialize(team, date)
    @team = team
    @start_on = date.beginning_of_month
  end

  def build
    monthly_target = team.monthly_targets.find_by(start_on: start_on)

    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "売上実績")
      f.xAxis(categories: categories(monthly_target))
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
  end

  private

  attr_reader :team, :start_on

  def categories(monthly_target)
    monthly_target.weekly_performances.map(&:formatted_week)
  end
end
