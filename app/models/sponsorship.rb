# frozen_string_literal: true

# == Schema Information
#
# Table name: sponsorships
#
#  id                  :bigint           not null, primary key
#  approved            :boolean          default(FALSE)
#  sponsorable_type    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sponsor_id          :integer
#  sponsorable_id      :integer
#  sponsorship_type_id :integer
#
# Indexes
#
#  index_sponsorships_on_approved                             (approved)
#  index_sponsorships_on_sponsor_id                           (sponsor_id)
#  index_sponsorships_on_sponsorable_type_and_sponsorable_id  (sponsorable_type,sponsorable_id)
#
class Sponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :sponsorable, polymorphic: true
  belongs_to :sponsorship_type
end
