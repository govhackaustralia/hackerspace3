# frozen_string_literal: true

class DemographicsController < ApplicationController
  before_action :authenticate_user!, :profile

  def edit
    return if @profile.employment_status.present?

    @profile.build_employment_status
  end

  def update
    @profile.update profile_params
    redirect_to next_page_path
  end

  private

  def next_page_path
    session[:user_return_to].presence || manage_account_path
  end

  def profile_params
    params.require(:profile).permit(*DEMOGRAPHIC_PARAMS,
      employment_status_attributes: EmploymentStatus.options,)
  end

  DEMOGRAPHIC_PARAMS = %i[
    gender
    first_peoples
    disability
    education
    age
    postcode
  ].freeze
end
