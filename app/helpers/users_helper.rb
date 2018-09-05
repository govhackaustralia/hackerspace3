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

  def in_challenge_judging_window?
    @competition.challenge_judging_start < Time.now &&
    Time.now < @competition.challenge_judging_end
  end
end
