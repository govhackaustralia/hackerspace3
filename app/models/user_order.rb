class UserOrder < ApplicationRecord
  belongs_to :bulk_mail
  has_many :correspondences, as: :orderable, dependent: :destroy
end
