class HuntQuestionsController < ApplicationController
  before_action :hunt_questions
  before_action :authenticate_user!, only: :update

  def index; end

  def update
    @question = HuntQuestion.find params[:id]
    award_question if @question.answer.downcase.match? attempt.downcase
    # award_hunt_badge if all_questions_answered?
    if @assignment&.save
      flash[:notice] =  'Question Answered!'
    else
      flash[:alert] = 'Please try again'
    end
    redirect_to scavenger_hunt_path
  end

  private

  def hunt_questions
    @questions = @competition.hunt_questions
  end

  def attempt
    params.require(:hunt_question).permit(:answer)[:answer]
  end

  def award_question
    @assignment = current_user.assignments.create(
      title: PARTICIPANT,
      assignable: @question,
      holder: holder
    )
  end

  def clear_answers
    @questions.map { |question| question.answer = '' }
  end

  # def award_hunt_badge
  #
  # end

  # def all_questions_answered?
  #
  # end
end
