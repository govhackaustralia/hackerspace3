# == Schema Information
#
# Table name: event_partnerships
#
#  id         :bigint           not null, primary key
#  event_id   :integer
#  sponsor_id :integer
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EventPartnership < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
end
