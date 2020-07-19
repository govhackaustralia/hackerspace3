class ConferenceController < ApplicationController
  def index
    all = @competition.events.published.preload(:region)
      .order start_time: :asc, name: :asc
    @future_sessions = all.conferences.future
    @past_sessions = all.conferences.past
  end
end
