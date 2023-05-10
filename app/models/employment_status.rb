# frozen_string_literal: true

# == Schema Information
#
# Table name: employment_statuses
#
#  id                       :bigint           not null, primary key
#  profile_id               :integer
#  full_time_employed       :boolean
#  part_time_casual         :boolean
#  self_employed            :boolean
#  full_time_student        :boolean
#  part_time_student        :boolean
#  not_employed_looking     :boolean
#  not_employed_not_looking :boolean
#  retired                  :boolean
#  not_able_to_work         :boolean
#  prefer_not_to_say        :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class EmploymentStatus < ApplicationRecord
  belongs_to :profile

  def self.options
    EmploymentStatus.new.attributes.map do |attribute, _value|
      attribute.to_sym
    end - %i[id profile_id created_at updated_at]
  end
end
