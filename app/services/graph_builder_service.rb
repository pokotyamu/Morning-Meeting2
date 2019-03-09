class GraphBuilderService
  def initialize(team, date)
    @team = team
    @start_on = date.beginning_of_month
    @monthly_target = team.monthly_targets.find_by(start_on: start_on)
  end

  def build
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "売上実績")
      f.xAxis(categories: categories)
      series_performance_values.each.with_index(1) do |value, index|
        f.series(yAxis: 0, stacking: 'normal', name: "#{index}週目", data: value )
      end
      f.series(name: "目標", data: series_target_values, type: 'line')
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
    end
  end

  private

  attr_reader :team, :start_on, :monthly_target

  def categories
    monthly_target.weekly_performances.map(&:formatted_week)
  end

  def series_performance_values
    monthly_target.weekly_performances.map.with_index do |performance, index|
      Array.new(index) + Array.new(weekly_performances_size - index, performance.value)
    end
  end

  def series_target_values
    [[0, monthly_target.value], [weekly_performances_size - 1, monthly_target.value]]
  end

  def weekly_performances_size
    @weekly_performances_size ||= monthly_target.weekly_performances.size
  end
end
