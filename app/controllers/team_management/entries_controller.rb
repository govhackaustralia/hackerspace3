class TeamManagement::EntriesController < TeamManagement::TeamsController
  before_action :check_in_comp_window!

  # ENHANCEMENT: Redo, too much logic in this controller that needs to be
  # pushed down into a model.

  # ENHANCEMENT: Reduce amount of calls made in the views
  def index
    @checkpoints = @competition.checkpoints.order :end_time
    @region = @team.region
  end

  def new
    @challenge = Challenge.find params[:challenge_id]
    @entry = @team.entries.new
    @checkpoints = @team.available_checkpoints @challenge
  end

  def create
    create_variables
    checkpoint = @entry.checkpoint
    checkpoint_not_passed = @checkpoints.include? checkpoint
    handle_create checkpoint_not_passed, checkpoint
  end

  def edit
    @entry = Entry.find(params[:id])
    @team = @entry.team
    @challenge = @entry.challenge
    @checkpoints = (@team.available_checkpoints(@challenge) << @entry.checkpoint).uniq
  end

  def update
    update_variables
    # ENHANCEMENT: Should be done in model validation.
    checkpoint = Checkpoint.find(params[:entry][:checkpoint_id])
    checkpoint_not_passed = @checkpoints.include?(checkpoint)
    handle_update(checkpoint_not_passed, checkpoint)
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:notice] = 'Challenge Entry Removed'
    redirect_to team_management_team_entries_path(@entry.team)
  end

  private

  def entry_params
    params.require(:entry).permit(
      :checkpoint_id,
      :justification,
      :challenge_id
    )
  end

  def create_variables
    @entry = @team.entries.new entry_params
    @challenge = @entry.challenge
    @checkpoints = @team.available_checkpoints(@challenge)
  end

  def update_variables
    @entry = Entry.find params[:id]
    @challenge = @entry.challenge
    @checkpoints = (@team.available_checkpoints(@challenge) << @entry.checkpoint).uniq
  end

  def handle_create(checkpoint_not_passed, checkpoint)
    if checkpoint_not_passed && @entry.save
      flash[:notice] = 'Challenge Entered'
      redirect_to challenge_path(@entry.challenge.identifier)
    else
      flash_alert checkpoint_not_passed, checkpoint
      render :new
    end
  end

  def handle_update(checkpoint_not_passed, checkpoint)
    if checkpoint_not_passed && @entry.update(entry_params)
      flash[:notice] = 'Entry Updated Successfully'
      redirect_to team_management_team_entries_path @team
    else
      flash_alert checkpoint_not_passed, checkpoint
      render :edit
    end
  end

  def flash_alert(checkpoint_not_passed, checkpoint)
    flash[:alert] = if checkpoint_not_passed
                      @entry.errors.full_messages.to_sentence
                    else
                      "#{checkpoint.name} has passed."
                    end
  end
end
