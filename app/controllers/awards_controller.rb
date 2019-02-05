class AwardsController < ApplicationController
  def index
    all = Competition.current.events.published.preload(:region).order(start_time: :asc, name: :asc)
    @future_awards = all.awards.future
    @past_awards = all.awards.past
  end
end
