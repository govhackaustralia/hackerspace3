# frozen_string_literal: true

module Types # rubocop:disable Style/ClassAndModuleChildren
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument
  end
end
