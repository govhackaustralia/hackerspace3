# frozen_string_literal: true

class AgreementsController < ApplicationController
  before_action :authenticate_user!, :user

  def edit; end

  def update
    if @user.update user_params
      redirect_to complete_registration_path,
        notice: 'Welcome! Please complete your registration.'
    else
      redirect_to review_terms_and_conditions_path,
        alert: 'Please accept our terms and conditions before continuing'
    end
  end

  private

  def user_params
    params.require(:user).permit(:accepted_terms_and_conditions)
  end

  def user
    @user = current_user
  end
end
