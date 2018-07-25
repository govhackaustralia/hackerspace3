class Event < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :attendances
  has_many :attendance_assignments, through: :attendances, source: :assignment
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true

  validates :registration_type, inclusion: { in: EVENT_REGISTRATION_TYPES }
  validates :category_type, inclusion: { in: EVENT_CATEGORY_TYPES }

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

  def attending(user)
    return true if attendances.find_by(assignment: user.event_assignment,
                                       status: INTENDING).present?
    false
  end

  def vips
    attendance_assignments.where(title: VIP)
  end

  def participants
    attendance_assignments.where(title: PARTICIPANT)
  end
end
