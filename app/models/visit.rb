class Visit < ApplicationRecord
  belongs_to :visitable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :competition
end
