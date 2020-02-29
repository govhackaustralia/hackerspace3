class ApplicationController < ActionController::Base
  before_action :competition, :accepted_terms_and_conditions,
                :filled_in_required_fields

  private

  def competition
    @competition = Competition.find_by_year request.subdomain
    @competition ||= Competition.current
  end

  def accepted_terms_and_conditions
    return unless ts_and_cs_conditions_not_met

    session[:user_return_to] = request.url
    flash[:notice] = 'Please accept our terms and conditions'
    redirect_to review_terms_and_conditions_path
  end

  def ts_and_cs_conditions_not_met
    return unless user_signed_in?
    return if current_user.accepted_terms_and_conditions
    return unless user_not_at_resolution_point

    true
  end

  def filled_in_required_fields
    return unless required_conditions_not_met

    flash[:notice] = 'Please complete the required fields.'
    redirect_to complete_registration_path
  end

  def required_conditions_not_met
    return unless user_signed_in?
    return unless current_user.full_name.blank?
    return unless user_not_at_resolution_point

    true
  end

  def user_not_at_resolution_point
    return unless user_not_editing_updating_account
    return if controller_name == 'omniauth_callbacks' && ['google'].include?(action_name)

    true
  end

  def user_not_editing_updating_account
    return if controller_name == 'users' && %w[
      edit
      update
      review_terms_and_conditions
      accept_terms_and_conditions
      complete_registration_edit
      complete_registration_update
    ].include?(action_name)
    return if controller_name == 'sessions' && ['destroy'].include?(action_name)

    true
  end
end
