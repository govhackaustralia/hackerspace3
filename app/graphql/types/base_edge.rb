# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  class BaseEdge < Types::BaseObject
    # add `node` and `cursor` fields, as well as `node_type(...)` override
    include GraphQL::Types::Relay::EdgeBehaviors
  end
end
