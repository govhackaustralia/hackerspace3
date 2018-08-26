class Favourite < ApplicationRecord
  belongs_to :team
  belongs_to :assignment
end
