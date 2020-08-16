class HuntQuestionsController < ApplicationController
  before_action :check_published!, :hunt_questions, :hunt_badge
  before_action :authenticate_user!, :check_for_previous_correct_answer!, only: :update

  def index
    clear_answers
    return unless user_signed_in?

    @hunt_badge_assignment = current_user.assignments.find_by(assignable: @hunt_badge)
  end

  def update
    if answered_correctly?
      handle_correct_answer
    else
      redirect_to treasure_hunt_path, alert: 'Incorrect Answer, Please try again'
    end
  end

  private

  def handle_correct_answer
    log_success_and_award_badge!
    if @badge_won
      redirect_to profile_path(current_user.profile),
        notice: "You have won the #{hunt_badge.name} badge!"
    else
      redirect_to treasure_hunt_path, notice: 'Question Answered!'
    end
  end

  def hunt_question
    @hunt_question ||= HuntQuestion.find params[:id]
  end

  def log_success_and_award_badge!
    Assignment.transaction do
      log_correctly_answered_question
      award_hunt_badge if all_questions_answered?
    end
  end

  def answered_correctly?
    hunt_question.answer.downcase.strip == attempt.downcase.strip
  end

  def hunt_questions
    @hunt_questions ||= @competition.hunt_questions.order(:question)
  end

  def hunt_badge
    @hunt_badge ||= @competition.hunt_badge
  end

  def attempt
    params.require(:hunt_question).permit(:answer)[:answer]
  end

  def log_correctly_answered_question
    current_user.assignments.create!(
      title: ASSIGNEE,
      assignable: hunt_question,
      holder: holder
    )
  end

  def clear_answers
    hunt_questions.map { |question| question.answer = '' }
  end

  def award_hunt_badge
    current_user.assignments.find_or_create_by!(
      title: ASSIGNEE,
      assignable: hunt_badge,
      holder: holder
    )
    @badge_won = true
  end

  def all_questions_answered?
    (hunt_questions.pluck(:id) - current_user.assignments.where(assignable: hunt_questions).pluck(:assignable_id)).empty?
  end

  def check_for_previous_correct_answer!
    return unless current_user.assignments.where(assignable: hunt_question).exists?

    redirect_to treasure_hunt_path, alert: 'Already answered question'
  end

  def check_published!
    return if @competition.hunt_published

    redirect_to root_url, alert: 'Treasure Hunt not available yet'
  end
end
