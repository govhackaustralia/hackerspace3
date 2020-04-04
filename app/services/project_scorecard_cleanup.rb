class ProjectScorecardCleanup
  def self.cleanup!
    @counter = 0
    Scorecard.all.preload(:scores).each do |scorecard|
      next if scorecard.scores.present?

      scorecard.destroy!
      @counter += 1
    end
    puts "#{@counter} Scorecards destroyed" unless Rails.env.test?
  end
end
