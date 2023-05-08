# == Schema Information
#
# Table name: visits
#
#  id             :bigint           not null, primary key
#  visitable_type :string           not null
#  visitable_id   :bigint           not null
#  user_id        :bigint
#  competition_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Visit < ApplicationRecord
  belongs_to :visitable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :competition
end
