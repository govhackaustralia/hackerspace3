class ApplicationController < ActionController::Base
  before_action :accept_terms_and_conditions
  before_action :fill_in_required_fields

  private

  def accept_terms_and_conditions
    return unless ts_and_cs_conditions_not_met
    flash[:notice] = 'Please accept our terms and conditions'
    redirect_to edit_user_path(current_user)
  end

  def ts_and_cs_conditions_not_met
    return unless user_signed_in?
    return if current_user.accepted_terms_and_conditions
    return unless user_not_at_resolution_point
    true
  end

  def fill_in_required_fields
    return unless required_conditions_not_met
    flash[:notice] = 'Please complete the required fields.'
    redirect_to edit_user_path(current_user)
  end

  def required_conditions_not_met
    return unless user_signed_in?
    return unless current_user.full_name.nil? || current_user.full_name == ''
    return unless user_not_at_resolution_point
    true
  end

  def user_not_at_resolution_point
    return unless user_not_editing_updating_account
    return if controller_name == 'omniauth_callbacks' && ['google'].include?(action_name)
    true
  end

  def user_not_editing_updating_account
    return if controller_name == 'users' && %w[edit update].include?(action_name)
    return if controller_name == 'sessions' && ['destroy'].include?(action_name)
    true
  end
end
