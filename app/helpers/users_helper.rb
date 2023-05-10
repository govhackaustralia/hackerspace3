# frozen_string_literal: true

module UsersHelper
  def user_has_admin_privileges?
    (@assignment_titles & COMP_ADMIN).present?
  end

  def user_has_region_privileges?
    (@assignment_titles & REGION_PRIVILEGES).present?
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
end
