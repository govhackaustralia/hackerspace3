module ContentPolicy
  extend ActiveSupport::Concern

  class ContentPolicyError < StandardError; end

  private

  def edit_template
    raise ContentPolicyError, "No edit template defined"
  end

  def check_content_policy!
    return if params[:accepted_content_policy]

    flash[:alert] = "Please accept the Govhack's Content Upload Policy"
    render edit_template
  end
end
