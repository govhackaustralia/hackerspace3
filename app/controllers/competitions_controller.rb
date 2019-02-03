class CompetitionsController < ApplicationController
  def show
    @competition = Competition.current
    retrieve_events
    @challenges = @competition.challenges.approved
    @teams = @competition.teams.published
    @data_sets = @competition.data_sets
  end

  private

  def retrieve_events
    @connections = @competition.events.published.future.connections
    @competition_events = @competition.events.published.future.competitions
    @awards = @competition.events.published.future.awards
  end
end
