class CompetitionsController < ApplicationController
  def index
    @competition = Competition.current
  end
end
