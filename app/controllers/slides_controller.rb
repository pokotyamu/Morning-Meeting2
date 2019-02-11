class SlidesController < ApplicationController
  def edit
    start_on = Date.today.beginning_of_buiginess_month

    @target = Target.find_or_initialize_by(
      team_id: team_id,
      start_on: start_on
    )

    if @target.persisted?
      @performances = @target.performances
    else
      @performances = Array.new(4) do |n|
        @target.performances.build(start_on: start_on + 7.days * n)
      end
    end
  end
end
