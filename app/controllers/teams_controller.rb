# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!, :check_participating!,
    :check_in_form_or_comp_window!

  def new
    @team = Team.new
  end

  def create
    @team = Team.new team_params
    @team.event = @participating_competition_event
    if @competition.in_form_or_comp_window? @team.region.time_zone
      create_team
    else
      flash[:alert] = "The competition has closed in region #{@team.region.name}"
      render :new
    end
  end

  private

  def team_params
    params.require(:team).permit :event_id, :youth_team
  end

  def check_in_form_or_comp_window!
    return if @competition.in_form_or_comp_window? @participating_competition_event.region.time_zone

    flash[:alert] = 'Team formation is not available at this time.'
    redirect_to projects_path
  end

  def check_participating!
    @participating_competition_event = current_user.participating_competition_event @competition
    return if @participating_competition_event.present?

    flash[:alert] = 'You must first be registered for a Competition Event.'
    redirect_to competition_events_path
  end

  def create_team
    if @team.save
      handle_team_save
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :new
    end
  end

  def handle_team_save
    @team.assign_leader current_user
    @team.projects.create(
      team_name: "Team #{@team.id}",
      project_name: "Project #{@team.id}",
      user: current_user
    )
    flash[:notice] = 'New Team Project Created'
    redirect_to team_management_team_path @team
  end
end
