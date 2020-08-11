class Admin::HuntQuestionsController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  def index
    @hunt_questions = @competition.hunt_questions.order(:question)
    @badges = @competition.badges.order(:name)
  end

  def new
    @hunt_question = HuntQuestion.new
  end

  def create
    @hunt_question = @competition.hunt_questions.new hunt_question_params
    if @hunt_question.save
      flash[:notice] = 'hunt_question created.'
      redirect_to admin_competition_hunt_questions_path @competition
    else
      flash[:alert] = @hunt_question.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @hunt_question = HuntQuestion.find params[:id]
  end

  def update
    @hunt_question = HuntQuestion.find params[:id]
    if @hunt_question.update(hunt_question_params)
      flash[:notice] = 'hunt_question updated.'
      redirect_to admin_competition_hunt_questions_path @competition
    else
      flash[:alert] = @hunt_question.errors.full_messages.to_sentence
      render :edit
    end
  end

  def badge
    @competition.update competition_params
    redirect_to admin_competition_hunt_questions_path
  end

  def hunt_published
    @competition.update competition_params
    redirect_to admin_competition_hunt_questions_path
  end

  private

  def authorize_user!
    @competition = Competition.find params[:competition_id]
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def hunt_question_params
    params.require(:hunt_question).permit(:question, :answer)
  end

  def competition_params
    params.require(:competition).permit(:hunt_badge_id, :hunt_published)
  end
end
