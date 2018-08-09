class Sponsor < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  belongs_to :competition
  has_many :sponsorships, dependent: :destroy
  has_many :event_partnerships, dependent: :destroy

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
end
