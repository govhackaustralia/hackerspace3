# frozen_string_literal: true

class API::V1::HealthController < API::V1::BaseController
  def show
    render json: {data: {version: ENV.fetch('COMMIT_SHA', 'unknown')}}
  end
end
