class ScorecardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @judgeable_assignment = @user.judgeable_assignment @competition
    Scorecard.transaction do
      Judgment.transaction do
        @scorecard = @team.scorecards.find_or_create_by(assignment: @judgeable_assignment)
        @judgments = organise_judgments
      end
    end
  end

  def edit
    @scorecard = Scorecard.find(params[:id])
    Scorecard.transaction do
      Judgment.transaction do
        @judgments = organise_judgments
      end
    end
    return if @user == @scorecard.user

    flash[:alert] = 'You do not have permission to edit this scorecard.'
    redirect_to root_path
  end

  # ENHANCEMENT: Hard to test, shape to REST.
  def update
    @scorecard = Scorecard.find(params[:id])
    if @user == @scorecard.user
      update_scorecard
      process_judgments
      redirect_to edit_project_scorecard_path(@team.current_project.identifier, @scorecard, popup: true)
    else
      flash[:alert] = 'You do not have permission to edit this scorecard.'
      redirect_to root_path
    end
  end

  private

  def check_for_privileges
    @user = current_user
    @project = Project.find_by(identifier: params[:project_identifier])
    @project = Project.find(params[:project_identifier]) if @project.nil?
    @team = @project.team
    @competition = @team.competition
    evaluate_access
  end

  def update_scorecard
    Scorecard.transaction do
      Judgment.transaction do
        @judgments = organise_judgments
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

  def process_judgments
    success = true
    @judgments.each do |judgment|
      new_score = params[:judgments][judgment.id.to_s][:score].to_i
      if validate_new_score(new_score)
        judgment.update(score: new_score)
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

  def organise_judgments
    @scorecards = [@scorecard]
    @scorecard.update_judgments
    assignments = Assignment.where(user: @user, title: JUDGE, assignable: @team.challenges).order(:id)
    all_judgments = @scorecard.judgments.order(:criterion_id)
    return all_judgments unless assignments.present?

    assignments.each { |assignment| all_judgments += organise_challenge_scorecard(assignment) }
    all_judgments
  end

  def organise_challenge_scorecard(assignment)
    entry = Entry.find_by(team: @team, challenge: assignment.assignable)
    scorecard = Scorecard.find_or_create_by(assignment: assignment, judgeable: entry)
    scorecard.update_judgments
    @scorecards << scorecard
    scorecard.judgments.order(:criterion_id)
  end
end
