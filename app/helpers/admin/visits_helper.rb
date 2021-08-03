module Admin::VisitsHelper
  def visitable(visits, type, id)
    visits.find do |visit|
      visit.visitable_type == type && visit.visitable_id == id
    end.visitable
  end
end
