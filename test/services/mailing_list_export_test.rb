require 'test_helper'

class MailingListExportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'csv' do
    MailingListExport.new(@competition).to_csv.class == String
  end
end
