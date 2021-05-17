class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_user!, :confirm_success!, only: :slack

  def google
    @user = google_sign_in request.env['omniauth.auth']
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      handle_auth_error
    end
  end

  def slack
    if profile.update profile_params
      flash[:notice] = 'Slack account successfully linked 🥳'
      render 'profiles/edit'
    else
      redirect_to profiles_path, alert: profile.errors.full_messages.to_sentence
    end
  end

  def failure
    redirect_to root_path, alert: 'Something went wrong ☹️'
  end

  private

  def confirm_success!
    return if data.fetch 'ok'

    redirect_to edit_profile_path(current_user.profile),
      alert: 'Something went wrong with Slack Connecting'
  end

  def profile_params
    {
      slack_user_id: data.dig('authed_user', 'id'),
      slack_access_token: data.fetch(:access_token)
    }
  end

  def data
    request.env['omniauth.strategy'].access_token.to_hash
  end

  def handle_auth_error
    session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
    redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  end

  def google_sign_in(access_token)
    data = access_token.info
    user = User.find_by_email data['email']
    user ||= new_user_from_google(data)
    update_user_info_from_google user, data
    user.save
    user
  end

  def new_user_from_google(data)
    User.new full_name: data['name'], email: data['email'],
             password: Devise.friendly_token[0, 20]
  end

  def update_user_info_from_google(user, data)
    user.google_img = data['image']
    return unless user.full_name.blank?

    user.full_name = data['name']
  end
end
