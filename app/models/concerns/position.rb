module Position
  extend ActiveSupport::Concern

  included do
    before_validation :make_a_space!
  end

  private

  def make_a_space!
    ActiveRecord::Base.transaction { candidates_to_update.each(&:save!) }
  end

  def candidates_to_update
    counter = position
    candidates_to_reposition.select do |instance|
      next false unless instance.position == counter

      counter += 1
      instance.position = counter
    end
  end

  def candidates_to_reposition
    raise 'Need to define a collection of records to update'
  end
end
