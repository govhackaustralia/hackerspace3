# == Schema Information
#
# Table name: badges
#
#  id             :bigint           not null, primary key
#  capacity       :integer
#  identifier     :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_badges_on_identifier  (identifier)
#
class Badge < ApplicationRecord
  belongs_to :competition

  has_many :assignments, as: :assignable, dependent: :destroy

  has_one_attached :art

  validates :name, presence: true

  validates :name, uniqueness: {
    scope: :competition_id,
    message: 'Badge name already taken in this competition'
  }

  validates :capacity, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }, allow_nil: true

  after_save_commit :update_identifier

  def to_param
    identifier
  end

  private

  def update_identifier
    update_columns identifier: generate_identifier
  end

  def generate_identifier
    new_identifier = uri_pritty name

    return new_identifier unless competition.badges.where(identifier: new_identifier).where.not(id: id).exists?

    uri_pritty "#{new_identifier}-#{Badge.where(identifier: new_identifier).count}"
  end
end
