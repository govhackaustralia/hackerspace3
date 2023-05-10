# frozen_string_literal: true

class Admin::EventsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @events = @competition.events.preload(:region, :attending_registrations, :registrations)
    @admin_privileges = current_user.admin_privileges? @competition
    @published_user_ids = Assignment.where(assignable: @competition.teams.published)
      .pluck(:user_id).uniq
    @participant_counts = @competition.competition_registrations
      .joins(:assignment)
      .where(status: ATTENDING, assignments: {user_id: @published_user_ids})
      .group('events.id').count
  end

  private

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.event_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
