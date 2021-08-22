class Resource < ApplicationRecord
  include Position

  has_many :visits, as: :visitable, dependent: :destroy

  belongs_to :competition

  scope :show_on_front_page, -> { where show_on_front_page: true }

  validates :category, :position, :name, :url, :short_url, presence: true
  validates :position, :name, uniqueness: { scope: %i[competition_id category],
    message: 'already taken in this competition' }

  enum category: {
    data_portal: 0,
    tech: 1,
    information: 2
  }

  private

  def candidates_to_reposition
    return [] if competition.nil?

    competition.resources
      .where(category: category)
      .where(position: position..)
      .where.not(id: self)
      .order(position: :asc)
  end
end
