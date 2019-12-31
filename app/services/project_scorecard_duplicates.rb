class ProjectScorecardDuplicates
  class << self
    def report
      @messages = []
      Scorecard.all.preload(:judgeable, :assignment).each do |scorecard|
        check_for_duplicates scorecard
      end
      puts @messages.join unless Rails.env.test?
    end

    def clean_up!
      @messages = []
      Scorecard.all.preload(
        :judgeable, :assignment, :judgments
      ).each { |scorecard| check_for_duplicates! scorecard }
      puts @messages.join unless Rails.env.test?
    end

    private

    def check_for_duplicates(scorecard)
      @messages << "scorecard: #{scorecard.id}, DUPLICATE, Scores: #{scorecard.judgments.order(:judgments).pluck(:score)}" if Scorecard.where(
        judgeable: scorecard.judgeable,
        assignment: scorecard.assignment
      ).count != 1
    end

    def check_for_duplicates!(scorecard)
      scorecards = Scorecard.where(
        judgeable: scorecard.judgeable,
        assignment: scorecard.assignment
      )
      remove_duplicates!(scorecards) if scorecards.length != 1
    end

    def remove_duplicates!(scorecards)
      if (candidates = retrieve_duplicate_canditates(scorecards)).present?
        candidates.each do |scorecard|
          scorecard.destroy!
          @messages << "Scorcard: #{scorecard.id}, DESTROYED"
        end
      else
        scorecards.each { |s| @messages << "Scorecard: #{s.id}, CONFLICT" }
      end
    end

    def retrieve_duplicate_canditates(scorecards)
      candidates = []
      scorecards.each do |scorecard|
        next unless (scorecard.judgments.pluck(:score) - [nil]).empty?

        candidates << scorecard
      end
      candidates
    end
  end
end
