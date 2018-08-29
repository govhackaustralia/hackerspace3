module Admin::EntriesHelper
  def ordered_challenge_entries
    @entries_and_scores = []
    @nil_entries = []
    @nil_eligible_entries = []
    @non_eligible_entries = []
    sort_entries
    @entries_and_scores.sort_by! { |obj| obj[:score] }.reverse!
  end

  def sort_entries
    @challenge.entries.each do |entry|
      score = entry.average_score
      if score.nil?
        sort_non_score(entry)
      else
        @entries_and_scores << { score: score, entry: entry }
      end
    end
  end

  def sort_non_score(entry)
    if entry.eligible.nil?
      @nil_eligible_entries << entry
    elsif entry.eligible == false
      @non_eligible_entries << entry
    else
      @nil_entries << entry
    end
  end
end
