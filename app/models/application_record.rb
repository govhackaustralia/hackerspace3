class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Converts a string to uri friendly string.
  def uri_pritty(string)
    CGI.escape((string.split(/\W/) - ['']).join('_').downcase)
  end

  # Checks to see if an identifier has been taken.
  def already_there?(model, new_identifier, instance)
    candidate = model.find_by identifier: new_identifier
    !(candidate.nil? || candidate == instance)
  end
end
