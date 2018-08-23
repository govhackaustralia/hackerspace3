class Admin::EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @challenge = Challenge.find(params[:challenge_id])
    ordered_challenge_entries
  end

  private

  def ordered_challenge_entries
    @entries_and_scores = []
    @nil_entries = []
    sort_entries
    @entries_and_scores.sort_by! { |obj| obj[:score] }.reverse!
  end

  def sort_entries
    @challenge.entries.each do |entry|
      score = entry.average_score
      if score.nil?
        @nil_entries << entry
      else
        @entries_and_scores << { score: score, entry: entry }
      end
    end
  end
end
