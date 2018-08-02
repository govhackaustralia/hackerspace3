class EventsController < ApplicationController
  def index
    @events = Competition.current.events
  end
end
