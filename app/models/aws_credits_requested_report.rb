class AwsCreditsRequestedReport
  def initialize(competition)
    @requests = competition.competition_registrations.aws_credits_requested.pluck(:event_id)
    @event_id_request_count = {}
    @requests.uniq.each do |event_id|
      @event_id_request_count[event_id] = @requests.count(event_id)
    end
  end

  def competition_count
    @requests.length
  end

  def region_count(region)
    region_count = 0
    region.events.pluck(:id).each do |event_id|
      event_count = @event_id_request_count[event_id]
      next if event_count.nil?

      region_count += event_count
    end
    region_count
  end

  def event_count(event)
    @event_id_request_count[event.id] || 0
  end
end
