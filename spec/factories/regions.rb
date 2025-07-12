# frozen_string_literal: true

# == Schema Information
#
# Table name: regions
#
#  id             :bigint           not null, primary key
#  award_release  :datetime
#  category       :string
#  identifier     :string
#  is_show        :integer
#  name           :string
#  time_zone      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#  parent_id      :integer
#
# Indexes
#
#  index_regions_on_competition_id  (competition_id)
#  index_regions_on_identifier      (identifier)
#  index_regions_on_parent_id       (parent_id)
#
FactoryBot.define do
  factory :region do
    category { 'International' }
    name { 'Default Region' }
  end
end
