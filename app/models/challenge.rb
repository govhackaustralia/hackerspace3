class Challenge < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  belongs_to :competition
  belongs_to :region
  has_many :sponsorships, as: :sponsorable
  has_many :entries, dependent: :destroy
  has_many :challenge_criteria, dependent: :destroy
  has_many :challenge_sponsorships, dependent: :destroy

  has_many :challenge_data_sets, dependent: :destroy
  has_many :data_sets, through: :challenge_data_sets

  has_one_attached :image
  has_one_attached :pdf
  has_one_attached :pdf_preview

  validates :name, presence: true
  validates :name, uniqueness: true

  def available_criteria
    used_criteria = Criterion.where(id: challenge_criteria.pluck(:criterion_id))
    competition.region_criteria - used_criteria
  end

  def admin_assignments
    competition = Competition.current
    collected = competition.admin_assignments
    collected << competition.assignments.where(title: CHIEF_JUDGE).to_a
    collected << region.admin_assignments
    collected.flatten
  end

  require 'csv'

  def self.to_csv(options = {})
    desired_columns = %w[id region_id competition_id name short_desc long_desc eligibility video_url created_at updated_at]
    CSV.generate(options) do |csv|
      csv << desired_columns
      all.each do |challenge|
        csv << challenge.attributes.values_at(*desired_columns)
      end
    end
  end
end
