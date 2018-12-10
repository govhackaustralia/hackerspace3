module UsersHelper
  def user_has_admin_privilieges?
    (@assignment_titles & COMP_ADMIN).present?
  end

  def user_has_event_privileges?
    (@assignment_titles & EVENT_PRIVILEGES).present?
  end

  def user_has_sponsor_privileges?
    (@assignment_titles & SPONSOR_PRIVILEGES).present?
  end

  def user_is_chief_judge?
    @assignment_titles.include? CHIEF_JUDGE
  end

  def user_is_a_judge?
    @assignment_titles.include? JUDGE
  end

  def user_is_a_sponsor_contact?
    @assignment_titles.include? SPONSOR_CONTACT
  end

  def user_invited_teams
    assignment_ids = @user.assignments.where(assignable_type: 'Team', title: INVITEE).pluck(:assignable_id)
    return if assignment_ids.nil?

    invited_teams = []
    Team.where(id: assignment_ids).each do |team|
      invited_teams << team if in_competition_window?(team.time_zone)
    end
    return invited_teams unless invited_teams.empty?
  end
end
