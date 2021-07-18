class EmploymentStatus < ApplicationRecord
  belongs_to :profile

  def self.options
    EmploymentStatus.new.attributes.map do |attribute, _value|
      attribute.to_sym
    end - %i[id profile_id created_at updated_at]
  end
end
