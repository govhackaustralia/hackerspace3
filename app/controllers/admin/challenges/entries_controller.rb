class Admin::Challenges::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @challenge = Challenge.find(params[:challenge_id])
    @judges = @challenge.users
    team_project_entries
    project_judging
    challenge_judging
  end

  def edit
    @entry = Entry.find(params[:id])
    @team = @entry.team
    @checkpoint = @entry.checkpoint
    @challenge = @entry.challenge
  end

  def update
    update_entry
    if @entry.save
      flash[:notice] = 'Entry Updated'
      redirect_to admin_challenge_entries_path(@challenge)
    else
      @team = @entry.team
      @checkpoint = @entry.checkpoint
      flash[:alert] = @entry.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def team_project_entries
    @entries =  @challenge.entries
    @id_entries = Entry.team_id_entries(@entries)
    @teams = Team.where(id: @entries.pluck(:team_id), published: true)
    @id_team_projects = Team.id_teams_projects(@teams)
    @projects = @challenge.published_projects_by_name
  end

  def project_judging
    @project_judging_total = @challenge.competition.score_total PROJECT
    @judge_event_assignments = []
    @judges.each { |judge| @judge_event_assignments << judge.event_assignment }
    @judge_project_scores = {}
    @judge_event_assignments.each do |judge_assignment|
      @judge_project_scores[judge_assignment.user_id] = judge_assignment.judgeable_scores(@teams)
    end
  end

  def challenge_judging
    @challenge_judging_total = @challenge.competition.score_total CHALLENGE
    @judge_assignments = @challenge.assignments
    @judge_challenge_scores = {}
    @judge_assignments.each do |judge_assignment|
      @judge_challenge_scores[judge_assignment.user_id] = judge_assignment.judgeable_scores(@teams)
    end
  end

  def update_entry
    @entry = Entry.find(params[:id])
    @challenge = @entry.challenge
    @entry.update(entry_params) if params[:entry].present?
  end

  def entry_params
    params.require(:entry).permit(:eligible, :award)
  end

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
