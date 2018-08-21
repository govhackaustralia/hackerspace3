class Admin::ChallengeCriteriaController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @challenge = Challenge.find(params[:challenge_id])
    @available_criteria = @challenge.available_criteria
  end

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @challenge_criterion = @challenge.challenge_criteria.new
    @available_criteria = @challenge.available_criteria
  end

  def create
    create_new_challenge_criterion
    if @challenge_criterion.save
      flash[:notice] = 'ChallengeCriterion created.'
      redirect_to admin_challenge_challenge_criteria_path(@challenge)
    else
      flash[:alert] = @challenge_criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @challenge = Challenge.find(params[:challenge_id])
    @challenge_criterion = ChallengeCriterion.find(params[:id])
    @available_criteria = @challenge.available_criteria << @challenge_criterion.criterion
  end

  def update
    retrieve_challenge_and_challenge_criterion
    if @challenge_criterion.update(challenge_criterion_params)
      flash[:notice] = 'Challenge criterion updated.'
      redirect_to admin_challenge_challenge_criteria_path(@challenge)
    else
      flash[:alert] = @challenge_criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def challenge_criterion_params
    params.require(:challenge_criterion).permit(:criterion_id, :description)
  end

  def retrieve_challenge_and_challenge_criterion
    @challenge = Challenge.find(params[:challenge_id])
    @challenge_criterion = ChallengeCriterion.find(params[:id])
  end

  def create_new_challenge_criterion
    @challenge = Challenge.find(params[:challenge_id])
    @challenge_criterion = @challenge.challenge_criteria.new(challenge_criterion_params)
  end
end
