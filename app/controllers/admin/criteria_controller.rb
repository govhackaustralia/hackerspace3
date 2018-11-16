class Admin::CriteriaController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.find(params[:competition_id])
  end

  def new
    @competition = Competition.find(params[:competition_id])
    @criterion = @competition.criteria.new
  end

  def create
    create_new_criterion
    if @criterion.save
      flash[:notice] = 'Criterion created.'
      redirect_to admin_competition_criteria_path(@competition)
    else
      flash[:alert] = @criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @competition = Competition.find(params[:competition_id])
    @criterion = Criterion.find(params[:id])
  end

  def update
    retrieve_competition_and_criterion
    if @criterion.update(criterion_params)
      flash[:notice] = 'Criterion updated.'
      redirect_to admin_competition_criteria_path(@competition)
    else
      flash[:alert] = @criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    return if current_user.criterion_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def criterion_params
    params.require(:criterion).permit(:category, :name, :description)
  end

  def retrieve_competition_and_criterion
    @competition = Competition.find(params[:competition_id])
    @criterion = Criterion.find(params[:id])
  end

  def create_new_criterion
    @competition = Competition.find(params[:competition_id])
    @criterion = @competition.criteria.new(criterion_params)
  end
end
