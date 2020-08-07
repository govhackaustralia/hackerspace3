class HuntQuestionsController < ApplicationController
  before_action :hunt_questions
  before_action :authenticate_user!, :check_for_previous_correct_answer!, only: :update

  def index
    return unless user_signed_in?

    @hunt_badge = current_user.assignments.find_by(assignable: @competition.hunt_badge)
  end

  def update
    if answered_correctly?
      log_success_and_award_badge!
      flash[:notice] =  'Question Answered!'
    else
      flash[:alert] = 'Please try again'
    end
    redirect_to scavenger_hunt_path
  end

  private

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
    hunt_question.answer.downcase.match? attempt.downcase.strip
  end

  def hunt_questions
    @hunt_questions ||= @competition.hunt_questions
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
    current_user.assignments.create!(
      title: ASSIGNEE,
      assignable: @competition.hunt_badge,
      holder: holder
    )
  end

  def all_questions_answered?
    (hunt_questions.pluck(:id) - current_user.assignments.where(assignable: hunt_questions).pluck(:assignable_id)).empty?
  end

  def check_for_previous_correct_answer!
    return unless current_user.assignments.where(assignable: hunt_question).exists?

    redirect_to scavenger_hunt_path, alert: 'Already answered question'
  end
end
