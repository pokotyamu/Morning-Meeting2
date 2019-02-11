class AnnouncementsController < ApplicationController
  def new
    if Date.today.monday?
      start_on = Date.today
    else
      start_on = Date.today.next_week.beginning_of_week
    end

    @announcement = Announcement.find_or_initialize_by(start_on: start_on)
  end

  def create
    Announcement.create(announcement_params)
    redirect_to root_url, notice: '保存しました'
  end

  def update
    announcement = Announcement.find_or_initialize_by(
      start_on: announcement_params['start_on']
    )
    announcement.update(announcement_params)
    redirect_to root_url, notice: '保存しました'
  end

  private

  def announcement_params
    params.require(:announcement).permit(:start_on, :content)
  end
end
