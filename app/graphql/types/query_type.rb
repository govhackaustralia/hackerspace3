# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :events,
      [Types::EventType],
      null: false,
      description: 'Returns a list of events in the hackerspace'

    field :regions,
      [Types::RegionType],
      null: false,
      description: 'Returns a list of region in the hackerspace'

    def events
      Event.all.preload(:region)
    end

    def regions
      Region.all.preload(:events)
    end
  end
end
