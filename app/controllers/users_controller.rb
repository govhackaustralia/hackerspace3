class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if current_user.update(user_params)
      flash[:notice] = 'Your personal details have been updated.'
      redirect_to manage_account_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :preferred_name, :preferred_img,
                                 :tshirt_size, :twitter, :mailing_list, :challenge_sponsor_contact_place,
                                 :challenge_sponsor_contact_enter, :my_project_sponsor_contact,
                                 :me_govhack_contact, :dietary_requirements, :organisation_name,
                                 :how_did_you_hear, :govhack_img_url)
  end
end
