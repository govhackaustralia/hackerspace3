class BadgePolicy
  def self.enough_badges?(badge)
    return true if badge.capacity.nil?

    badge.assignments.count < badge.capacity
  end
end
