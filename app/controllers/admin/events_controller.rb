class Admin::EventsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @events = @competition.events.preload(:region, :attending_registrations, :registrations)
    @admin_privileges = current_user.admin_privileges? @competition
  end

  private

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.event_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
