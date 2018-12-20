class Admin::Challenges::ChallengeDataSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @challenge_data_set = @challenge.challenge_data_sets.new
    return if params[:term].blank?

    search_data_sets
  end

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @data_set = DataSet.find(params[:data_set_id])
    @challenge_data_set = @challenge.challenge_data_sets.new(data_set: @data_set)
    handle_create_save
  end

  def destroy
    @challenge_data_set = ChallengeDataSet.find(params[:id])
    @challenge_data_set.destroy
    @challenge = @challenge_data_set.challenge
    flash[:notice] = 'Challenge Data Set Destroyed'
    redirect_to admin_region_challenge_path(@challenge.region_id, @challenge)
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def handle_create_save
    if @challenge_data_set.save
      flash[:notice] = 'New Challenge Data Set Added'
      redirect_to admin_region_challenge_path(@challenge.region_id, @challenge)
    else
      flash[:alert] = @challenge_data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def search_data_sets
    @data_set = DataSet.find_by_url(params[:term])
    if @data_set.present?
      @existing_challenge_data_set = ChallengeDataSet.find_by(data_set: @data_set, challenge: @challenge)
    else
      @data_sets = DataSet.search(params[:term])
    end
  end
end
