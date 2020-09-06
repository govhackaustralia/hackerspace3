class ScorecardsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges
  before_action :authorise_edit_update!, only: %i[edit update]

  def new
    @judgeable_assignment = @user.judgeable_assignment @competition
    Header.transaction do
      Score.transaction do
        @header= @team.headers.find_or_create_by(assignment: @judgeable_assignment)
        @scores = organise_scores
      end
    end
  end

  def edit
    Header.transaction do
      Score.transaction do
        @scores = organise_scores
      end
    end
  end

  # ENHANCEMENT: Hard to test, shape to REST.
  def update
    update_scorecard
    process_scores
    redirect_to edit_project_scorecard_path(@team.current_project.identifier, @header, popup: true)
  end

  private

  def authorise_edit_update!
    @header= Header.find params[:id]
    return if @user == @header.user

    redirect_to root_path,
      alert: 'You do not have permission to edit this scorecard.'
  end

  def check_for_privileges
    @user = @acting_on_behalf_of_user.presence || current_user
    @project = Project.find_by(identifier: params[:project_identifier])
    @project = Project.find(params[:project_identifier]) if @project.nil?
    @team = @project.team
    @competition = @team.competition
    evaluate_access
  end

  def update_scorecard
    Header.transaction do
      Score.transaction do
        @scores = organise_scores
      end
    end
  end

  def evaluate_access
    @peoples_assignment = @user.peoples_assignment @competition
    @judge = @user.judge_assignment(@team.challenges)
    return if @peoples_assignment.present? && @competition.in_peoples_judging_window?(LAST_TIME_ZONE)
    return if @judge.present? && @competition.in_challenge_judging_window?(LAST_TIME_ZONE)

    flash[:alert] = 'Scorecards are not available at this time.'
    redirect_to root_path
  end

  def process_scores
    success = true
    @scores.each do |score|
      new_score = params[:scores][score.id.to_s][:entry].to_i
      if validate_new_score(new_score)
        score.update(entry: new_score)
      else
        success = false
      end
    end
    success
  end

  def validate_new_score(new_score)
    return false if new_score.blank?

    (MIN_SCORE..MAX_SCORE).cover?(new_score)
  end

  def organise_scores
    @headers = [@header]
    @header.update_scores
    assignments = Assignment.where(user: @user, title: JUDGE, assignable: @team.challenges).order(:id)
    all_scores = @header.scores.order(:criterion_id)
    return all_scores unless assignments.present?

    assignments.each { |assignment| all_scores += organise_challenge_header(assignment) }
    all_scores
  end

  def organise_challenge_header(assignment)
    entry = Entry.find_by(team: @team, challenge: assignment.assignable)
    header = Header.find_or_create_by!(assignment: assignment, scoreable: entry)
    header.update_scores
    @headers << header
    header.scores.order(:criterion_id)
  end
end
