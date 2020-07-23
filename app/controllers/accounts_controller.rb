class AccountsController < ApplicationController
  before_action :authenticate_user!, :user

  def edit; end

  def update
    if @user.update(user_params) && @user.registration_complete?
      redirect_to next_page_path,
        notice: 'Your account has been created'
    else
      redirect_to complete_registration_path,
        alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.require(:user).permit(*ACCOUNT_PARAMS)
  end

  def next_page_path
    session[:user_return_to].presence || manage_account_path
  end

  def user
    @user = current_user
  end

  ACCOUNT_PARAMS = %i[
    full_name
    preferred_name
    mailing_list
    how_did_you_hear
    challenge_sponsor_contact_place
    challenge_sponsor_contact_enter
    my_project_sponsor_contact
    me_govhack_contact
    gender
    under_18
    region
  ].freeze
end
