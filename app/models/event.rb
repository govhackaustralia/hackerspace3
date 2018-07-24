class Event < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :attendances
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true

  def host
    assignment = assignments.where(title: EVENT_HOST).first
    return assignment if assignment.nil?
    assignment.user
  end

  def supports
    supports = []
    assignments.where(title: EVENT_SUPPORT).each do |assignment|
      supports << assignment.user
    end
    supports
  end
end
