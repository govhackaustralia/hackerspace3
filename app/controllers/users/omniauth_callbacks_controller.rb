class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      handle_auth_error
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def handle_auth_error
    session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
    redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  end
end
