# frozen_string_literal: true

class ConnectionsController < ApplicationController
  def index
    all = @competition.events.published.preload(:region).order(start_time: :asc, name: :asc)
    @past_connections = all.connections.past
    @future_connections = all.connections.future

    respond_to do |format|
      format.html
      format.json { render json: {past_connections: @past_connections, future_connections: @future_connections} }
    end
  end
end
