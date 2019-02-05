class ConnectionsController < ApplicationController
  def index
    all = Competition.current.events.published.preload(:region).order(start_time: :asc, name: :asc)
    @past_connections = all.connections.past
    @future_connections = all.connections.future
  end
end
