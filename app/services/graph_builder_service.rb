class GraphBuilderService
  def initialize(team, date)
    @team = team
    @start_on = date.beginning_of_month
  end

  def build
    monthly_target = team.monthly_targets.find_by(start_on: start_on)
    series_data = series_data(monthly_target)

    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "売上実績")
      f.xAxis(categories: categories(monthly_target))
      series_data.each_with_index do |data, index|
        f.series(yAxis: 0, stacking: 'normal', name: index.to_s, data: data )
      end
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

  def series_data(monthly_target)
    size = monthly_target.weekly_performances.size

    monthly_target.weekly_performances.map.with_index do |performance, index|
      Array.new(index) + Array.new(size - index, performance.value)
    end
  end
end
