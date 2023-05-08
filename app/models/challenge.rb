# == Schema Information
#
# Table name: challenges
#
#  id          :bigint           not null, primary key
#  region_id   :integer
#  name        :string
#  short_desc  :text
#  long_desc   :text
#  eligibility :text
#  video_url   :string
#  approved    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identifier  :string
#  nation_wide :boolean
#
class Challenge < ApplicationRecord
  belongs_to :region
  has_one :competition, through: :region

  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :judge_users, through: :assignments, source: :user
  has_many :entries, dependent: :destroy
  has_many :published_entries, -> { published }, class_name: 'Entry'
  has_many :teams, through: :entries
  has_many :published_teams, -> { published }, through: :entries, source: :team
  has_many :published_projects_by_name, -> { order(:project_name) }, through: :published_teams, source: :current_project
  has_many :challenge_sponsorships, dependent: :destroy
  has_many :sponsors, through: :challenge_sponsorships
  has_many :sponsors_with_logos, -> { with_attached_logo }, through: :challenge_sponsorships, source: :sponsor
  has_many :challenge_data_sets, dependent: :destroy
  has_many :data_sets, through: :challenge_data_sets

  has_one_attached :banner_image
  has_one_attached :image
  has_one_attached :pdf
  has_one_attached :pdf_preview

  scope :approved, -> { where approved: true }
  scope :not_unapproved, -> { where(approved: [nil, true]) }
  scope :nation_wides, -> { where nation_wide: true }

  validates :name, presence: true, uniqueness: true

  validate :only_regional_challenges_can_be_marked_nation_wide

  after_save_commit :update_identifier

  # ENHANCEMENT: This should be in active record relation but can't pass
  # parameter. eg
  # has_many entries_at, -> (checkpoint) { where('checkpoint_id = ?', checkpoint.id) }
  def entries_at(checkpoint)
    entries.where(checkpoint: checkpoint)
  end

  # Returns an array of all admin assignments associated with challenges in
  # particular competition.
  # ENHANCEMENT: This should probably be in a controller.
  def admin_assignments
    collected = competition.admin_assignments
    collected << competition.assignments.chief_judges.to_a
    collected << region.admin_assignments
    collected.flatten
  end

  # Returns a query object of the teams that are eligible to join a challenge.
  def eligible_teams
    return region.parent.competing_teams if nation_wide

    region.competing_teams
  end

  # Returns the type of region that a challenge is associated with.
  # ENHANCEMENT: This needs to split up into methods 'national?' 'regional?'
  def type
    region.international? || region.national? ? NATIONAL : REGIONAL
  end

  require 'csv'

  # Compiles a CSV file of all challenges.
  # ENHANCEMENT: This should be in a helper object or own model.
  def self.to_csv(competition, options = {})
    challenge_columns = %w[id name short_desc long_desc eligibility video_url created_at updated_at]
    CSV.generate(options) do |csv|
      csv << (%w[region_name competition_year] + challenge_columns + %w[sponsors entries])
      competition.challenges.preload(:region, :sponsors, :published_entries).each do |challenge|
        csv << challenge_csv_line(challenge, competition, challenge_columns)
      end
    end
  end

  # Compiles a single entry for the CSV file.
  # ENHANCEMENT: This should be in a helper object or own model.
  def self.challenge_csv_line(challenge, competition, challenge_columns)
    values = [challenge.region.name, competition.year]
    values += challenge.attributes.values_at(*challenge_columns)
    values << challenge.sponsors.pluck(:name)
    values << challenge.published_entries.length
  end

  private

  def only_regional_challenges_can_be_marked_nation_wide
    return unless nation_wide && type == NATIONAL

    errors.add :region, 'only regional challenges can be marked nation wide'
  end

  # Generates a unique name and updates the identifier field.
  def update_identifier
    new_identifier = uri_pritty name
    new_identifier = uri_pritty "#{name}-#{id}" if already_there? Challenge, new_identifier, self
    update_columns identifier: new_identifier
  end
end
