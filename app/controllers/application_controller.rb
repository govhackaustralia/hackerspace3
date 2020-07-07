class ApplicationController < ActionController::Base
  before_action :competition, :check_accepted_terms_and_conditions!,
                :check_required_fields!, :holder

  private

  def competition
    @competition = Competition.find_by_year request.subdomain
    @competition ||= Competition.current
  end

  def holder
    return unless user_signed_in?

    @holder = current_user.holder_for(@competition)
  end

  def profile
    return unless user_signed_in?

    @profile ||= Profile.find_or_create_by user: current_user
  end

  def check_accepted_terms_and_conditions!
    return if terms_and_conditions_completed? || user_at_resolution_point?

    session[:user_return_to] = request.url
    redirect_to review_terms_and_conditions_path,
      notice: 'Please accept our terms and conditions'
  end

  def terms_and_conditions_completed?
    return true unless user_signed_in?

    current_user.accepted_terms_and_conditions.present?
  end

  def check_required_fields!
    return if required_fields_complete? || user_at_resolution_point?

    redirect_to complete_registration_path,
      notice: 'Please complete the required fields.'
  end

  def required_fields_complete?
    return true unless user_signed_in?

    current_user.full_name.present? && current_user.region.present?
  end

  def user_at_resolution_point?
    user_editing_updating_account? || user_logging_out? || google_authing?
  end

  def user_editing_updating_account?
    %w[agreements accounts].include?(controller_name) &&
    %w[edit update].include?(action_name)
  end

  def google_authing?
    controller_name == 'omniauth_callbacks' && action_name == 'google'
  end

  def user_logging_out?
    controller_name == 'sessions' && action_name == 'destroy'
  end
end
