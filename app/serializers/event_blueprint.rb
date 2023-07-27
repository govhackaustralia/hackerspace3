# frozen_string_literal: true

class EventBlueprint < Blueprinter::Base
  identifier :id
  fields :address, :name, :description, :start_time, :end_time, :region_id, :event_type, :accessibility, :capacity,
    :catering, :email, :identifier, :operation_hours, :parking, :public_transport, :published, :registration_type,
    :twitter, :youth_support, :created_at, :updated_at, :place_id, :region_id, :video_id
end
