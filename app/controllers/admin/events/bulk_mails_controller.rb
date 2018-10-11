class Admin::Events::BulkMailsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find(params[:event_id])
    @region = @event.region
    @bulk_mails = @event.bulk_mails
  end

  def new
    @event = Event.find(params[:event_id])
    @bulk_mail = @event.bulk_mails.new
  end

  def create
    @event = Event.find(params[:event_id])
    @bulk_mail = @event.bulk_mails.new(bulk_mail_params)
    @bulk_mail.user = current_user
    @bulk_mail.status = DRAFT
    if @bulk_mail.save
      @bulk_mail.user_orders.create
      flash[:notice] = 'New Bulk Mail Order Created'
      redirect_to admin_event_bulk_mail_path(@event, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @bulk_mail = BulkMail.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @bulk_mail = BulkMail.find(params[:id])
    @event = Event.find(params[:event_id])
    @bulk_mail.update(bulk_mail_params) unless params[:bulk_mail].nil?
    process_team_orders unless params[:process].nil?
    if @bulk_mail.save
      flash[:notice] = 'Bulk Mail Updated'
      redirect_to admin_event_bulk_mail_path(@event, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :edit
    end
  end

  def show
    @bulk_mail = BulkMail.find(params[:id])
    @event = @bulk_mail.mailable
    @participant_count = 0
    @example_user = User.first
    @example_project = Project.first
    @user_order = UserOrder.find_by(bulk_mail: @bulk_mail)
    @registrations = @user_order.registrations(@event)
    assignments = Assignment.where(id: @registrations.pluck(:assignment_id))
    @id_assignments = Assignment.id_assignments(assignments)
    @id_users = User.id_users(User.where(id: assignments.pluck(:user_id)))
    return unless @bulk_mail.status == PROCESSED
    @id_user_correspondences = Correspondence.id_user_correspondences(@bulk_mail)
  end

  private

  def bulk_mail_params
    params.require(:bulk_mail).permit(:name, :from_email, :subject, :body)
  end

  def check_for_privileges
    return if current_user.event_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def process_team_orders
    @bulk_mail.update(status: PROCESS)
    BulkMailOutJob.perform_later(@bulk_mail)
  end
end
