class Admin::BulkMails::UserOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def update
    @user_order = UserOrder.find(params[:id])
    @bulk_mail = @user_order.bulk_mail
    @mailable =  @bulk_mail.mailable
    @user_order.update(user_order_params)
    if @user_order.save
      flash[:notice] = 'Order Updated'
    else
      flash[:alert] = @user_order.errors.full_messages.to_sentence
    end
    redirect_to [:admin, @mailable, @bulk_mail]
  end

  private

  def user_order_params
    params.require(:user_order).permit(:request_type)
  end

  def check_for_privileges
    return if current_user.event_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
