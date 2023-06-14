# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  accessibility     :text
#  address           :text
#  capacity          :integer
#  catering          :text
#  description       :text
#  email             :string
#  end_time          :datetime
#  event_type        :string
#  identifier        :string
#  name              :string
#  operation_hours   :text
#  parking           :text
#  public_transport  :text
#  published         :boolean          default(FALSE)
#  registration_type :string
#  start_time        :datetime
#  twitter           :string
#  youth_support     :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  place_id          :string
#  region_id         :integer
#  video_id          :string
#
# Indexes
#
#  index_events_on_identifier  (identifier)
#  index_events_on_published   (published)
#  index_events_on_region_id   (region_id)
#
FactoryBot.define do
  factory :event do
    name { 'Default Event' }
    capacity { 100 }
    registration_type { 'Open' }
    event_type { 'Competition' }
  end
end
