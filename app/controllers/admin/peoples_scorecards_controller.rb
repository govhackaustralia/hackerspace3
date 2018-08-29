class Admin::PeoplesScorecardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @competition = Competition.find(params[:competition_id])
  end
end
