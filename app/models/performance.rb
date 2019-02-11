# == Schema Information
#
# Table name: performances
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_on   :date             not null
#  value      :integer          default(0), not null
#  content    :text             not null
#  target_id  :integer          not null
#

class Performance < ApplicationRecord
  belongs_to :target

  def formatted_week
    "#{start_on.strftime("%m/%d")} から #{start_on.end_of_week.strftime("%m/%d")}"
  end
end
