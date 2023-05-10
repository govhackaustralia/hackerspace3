# frozen_string_literal: true

module Admin::VisitsHelper
  def visitable(visits, type, id)
    visits.find do |visit|
      visit.visitable_type == type && visit.visitable_id == id
    end.visitable
  end

  def visitable_label(visitable)
    return visitable.category.titleize if visitable.is_a? Resource

    visitable.class.to_s.titleize
  end
end
