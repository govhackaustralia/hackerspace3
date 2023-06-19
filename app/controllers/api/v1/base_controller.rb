# frozen_string_literal: true

class API::V1::BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  # Follows the JSON API spec for error responses
  # https://jsonapi.org/format/#errors
  def record_not_found
    render json: {
      errors: [
        {
          status: '404',
          title: 'Record not found',
          detail: 'The record you requested could not be found',
        },
      ],
    }, status: :not_found
  end
end
