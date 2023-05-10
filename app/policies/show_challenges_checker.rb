# frozen_string_literal: true

class ShowChallengesChecker
  attr_reader :competition

  def initialize(competition)
    @competition = competition
  end

  def show?(region)
    return false unless competition.started?(region.time_zone) ||
                        region.international?

    region.approved_challenges.any?
  end
end
