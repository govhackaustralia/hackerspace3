class DemographicsController < ApplicationController
  before_action :authenticate_user!, :profile

  def edit; end

  def update
    @profile.update profile_params
    redirect_to next_page_path
  end

  private

  def next_page_path
    session[:user_return_to].presence || manage_account_path
  end

  def profile_params
    params.require(:profile).permit(*DEMOGRAPHIC_PARAMS)
  end

  DEMOGRAPHIC_PARAMS = %i[
    gender
    first_peoples
    disability
    education
    employment
    age
    postcode
  ].freeze
end
