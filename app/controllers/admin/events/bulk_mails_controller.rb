class Admin::Events::BulkMailsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find params[:event_id]
    @region = @event.region
    @bulk_mails = @event.bulk_mails
  end

  def show
    @bulk_mail = BulkMail.find params[:id]
    @event = @bulk_mail.mailable
    show_helpers
    @correspondences = @bulk_mail.correspondences
  end

  def new
    @event = Event.find params[:event_id]
    @bulk_mail = @event.bulk_mails.new
  end

  def create
    @event = Event.find params[:event_id]
    @bulk_mail = @event.bulk_mails.new bulk_mail_params
    @bulk_mail.user = current_user
    @bulk_mail.status = DRAFT
    handle_create
  end

  def edit
    @bulk_mail = BulkMail.find params[:id]
    @event = Event.find params[:event_id]
  end

  def update
    @bulk_mail = BulkMail.find params[:id]
    @event = Event.find params[:event_id]
    @bulk_mail.update bulk_mail_params
    handle_update
  end

  private

  def bulk_mail_params
    params.require(:bulk_mail).permit :name, :from_email, :subject, :body
  end

  def show_helpers
    @participant_count = 0
    @example_user = User.first
    @example_project = Project.first
    @user_order = UserOrder.find_by bulk_mail: @bulk_mail
    @registrations = @user_order.registrations @event
    @registrations.preload(:user) unless @registrations.empty?
  end

  def handle_update
    if @bulk_mail.save
      flash[:notice] = 'Bulk Mail Updated'
      redirect_to admin_event_bulk_mail_path(@event, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :edit
    end
  end

  def handle_create
    if @bulk_mail.save
      @bulk_mail.user_orders.create
      flash[:notice] = 'New Bulk Mail Order Created'
      redirect_to admin_event_bulk_mail_path @event, @bulk_mail
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :new
    end
  end

  def check_for_privileges
    return if current_user.event_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
