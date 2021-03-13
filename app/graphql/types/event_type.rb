module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :region, Types::RegionType, null: false
    field :name, String, null: true
    field :registration_type, String, null: true
    field :capacity, Integer, null: true
    field :email, String, null: true
    field :twitter, String, null: true
    field :address, String, null: true
    field :accessibility, String, null: true
    field :youth_support, String, null: true
    field :parking, String, null: true
    field :public_transport, String, null: true
    field :operation_hours, String, null: true
    field :catering, String, null: true
    field :video_id, String, null: true
    field :start_time, GraphQL::Types::ISO8601DateTime, null: true
    field :end_time, GraphQL::Types::ISO8601DateTime, null: true
    field :published, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :place_id, String, null: true
    field :identifier, String, null: true
    field :event_type, String, null: true
    field :description, String, null: true
  end
end
