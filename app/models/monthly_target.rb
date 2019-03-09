# == Schema Information
#
# Table name: monthly_targets
#
#  id         :integer          not null, primary key
#  start_on   :date             not null
#  value      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer          not null
#

class MonthlyTarget < ApplicationRecord
  belongs_to :team
  has_many :weekly_performances
end
