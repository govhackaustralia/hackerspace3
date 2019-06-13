class CompetitionEventsController < ApplicationController
  def index
    all = @competition.events.published.preload(:region).order(start_time: :asc, name: :asc)
    @future_locations = all.locations.future
    @future_remotes = all.remotes.future
    @past_competitions = all.competitions.past
  end
end
