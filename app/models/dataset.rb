# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :bigint           not null, primary key
#  name        :string
#  url         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Dataset < ApplicationRecord
  scope :search, lambda { |term|
    where 'datasets.name ILIKE ? OR url ILIKE ? OR description ILIKE ?',
      "%#{term}%", "%#{term}%", "%#{term}%"
  }

  validates :name, presence: true
end
