# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
