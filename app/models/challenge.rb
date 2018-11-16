class Challenge < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :users, through: :assignments
  belongs_to :competition
  belongs_to :region
  has_many :entries, dependent: :destroy
  has_many :teams, through: :entries
  has_many :challenge_sponsorships, dependent: :destroy
  has_many :sponsors, through: :challenge_sponsorships
  has_many :challenge_data_sets, dependent: :destroy
  has_many :data_sets, through: :challenge_data_sets

  has_one_attached :image
  has_one_attached :pdf
  has_one_attached :pdf_preview

  validates :name, presence: true
  validates :name, uniqueness: true

  after_save :update_identifier

  def admin_assignments
    competition = Competition.current
    collected = competition.admin_assignments
    collected << competition.assignments.where(title: CHIEF_JUDGE).to_a
    collected << region.admin_assignments
    collected.flatten
  end

  def eligible_teams
    if region.national?
      competition.teams
    else
      region.teams
    end
  end

  def type
    return NATIONAL if region.national?

    REGIONAL
  end

  require 'csv'

  def self.to_csv(options = {})
    id_regions = Region.id_regions(Region.all)
    competition = Competition.current
    desired_columns = %w[id region_name competition_year name short_desc long_desc eligibility video_url sponsors created_at updated_at]
    CSV.generate(options) do |csv|
      csv << desired_columns
      all.each do |challenge|
        values = []
        values << challenge.id
        values << id_regions[challenge.region_id].name
        values << competition.year
        values += [challenge.name, challenge.short_desc, challenge.long_desc, challenge.eligibility, challenge.video_url]
        values << challenge.sponsors.pluck(:name)
        values += [challenge.created_at, challenge.updated_at]
        csv << values
      end
    end
  end

  def update_identifier
    new_identifier = uri_pritty(name)
    new_identifier = uri_pritty("#{name}-#{id}") if already_there?(new_identifier)
    update_columns(identifier: new_identifier)
  end

  def self.id_challenges(challenges)
    id_challenges = {}
    challenges.each { |challenge| id_challenges[challenge.id] = challenge }
    id_challenges
  end

  private

  def already_there?(new_identifier)
    challenge = Challenge.find_by(identifier: new_identifier)
    return false if challenge.nil?
    return false if challenge == self

    true
  end

  def uri_pritty(string)
    array = string.split(/\W/)
    words = array - ['']
    new_name = words.join('_')
    CGI.escape(new_name.downcase)
  end
end
