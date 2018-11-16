class BulkMailOutJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    BulkMail.where(status: PROCESS).each(&:process)
  end
end
