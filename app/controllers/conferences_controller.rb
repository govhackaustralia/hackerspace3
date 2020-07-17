class ConferencesController < ApplicationController
  def index
    all = @competition.events.published.preload(:region)
      .order start_time: :asc, name: :asc
    @future_conferences = all.conferences.future
    @past_conferences = all.conferences.past
  end
end
