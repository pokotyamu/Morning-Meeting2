# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  start_on   :date             not null
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer          not null
#

class Target < ApplicationRecord
  belongs_to :team
  has_many :performances
end
