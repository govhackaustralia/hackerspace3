class Sponsor < ApplicationRecord
  belongs_to :competition

  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :sponsorships, dependent: :destroy
  has_many :event_partnerships, dependent: :destroy
  has_many :challenge_sponsorships, dependent: :destroy

  has_one_attached :logo

  validates :name, uniqueness: true
  validates :name, presence: true

  def self.search(term)
    results = []
    Sponsor.all.each do |sponsor|
      sponsor_string = "#{sponsor.name} #{sponsor.description}".downcase
      results << sponsor if sponsor_string.include? term.downcase
    end
    results
  end

  def show_privileges?(user)
    (user.assignments.pluck(:title) & [SPONSOR_CONTACT]).present?
  end

  def admin_assignments
    collected = assignments.where(title: SPONSOR_ADMIN).to_a
    collected << competition.admin_assignments
    collected << Assignment.where(title: REGION_ADMIN).to_a
    collected.flatten
  end

  def self.id_sponsors(sponsor_ids)
    sponsors = where(id: sponsor_ids.uniq)
    id_sponsors = {}
    sponsors.each { |sponsor| id_sponsors[sponsor.id] = sponsor }
    id_sponsors
  end
end
