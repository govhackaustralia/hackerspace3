class ConnectionsController < ApplicationController
  def index
    all = @competition.events.published.preload(:region).order(start_time: :asc, name: :asc)
    @past_connections = all.connections.past
    @future_connections = all.connections.future
  end
end
