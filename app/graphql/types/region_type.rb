# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  class RegionType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :time_zone, String, null: true
    field :parent_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :competition_id, Integer, null: true
    field :category, String, null: true
    field :identifier, String, null: true
    field :events, [Types::EventType], null: true
  end
end
