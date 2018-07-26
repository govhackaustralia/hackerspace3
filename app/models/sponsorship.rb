class Sponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :sponsorable, polymorphic: true
  belongs_to :sponsorship_type
end
