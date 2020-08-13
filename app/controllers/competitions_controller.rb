class CompetitionsController < ApplicationController
  def show
    retrieve_events
    @any_challenges = @competition.challenges.approved.exists?
    @any_teams = @competition.teams.published.exists?
  end

  private

  def retrieve_events
    @event_counts = @competition.events.published.future.group(:event_type).count
  end
end
