class ProjectScorecardCleanup
  def self.cleanup!
    @counter = 0
    Scorecard.all.preload(:judgments).each do |scorecard|
      next if scorecard.judgments.present?

      scorecard.destroy!
      @counter += 1
    end
    puts "#{@counter} Scorecards destroyed" unless Rails.env.test?
  end
end
