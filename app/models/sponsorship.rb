# == Schema Information
#
# Table name: sponsorships
#
#  id                  :bigint           not null, primary key
#  sponsor_id          :integer
#  sponsorship_type_id :integer
#  sponsorable_type    :string
#  sponsorable_id      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  approved            :boolean          default(FALSE)
#
class Sponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :sponsorable, polymorphic: true
  belongs_to :sponsorship_type
end
