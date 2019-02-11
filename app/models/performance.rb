# == Schema Information
#
# Table name: performances
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_on   :datetime         not null
#  value      :integer          not null
#  content    :text             not null
#  target_id  :integer          not null
#

class Performance < ApplicationRecord
  belongs_to :target
end
