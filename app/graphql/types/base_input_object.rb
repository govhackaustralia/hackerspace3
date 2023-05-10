# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
end
