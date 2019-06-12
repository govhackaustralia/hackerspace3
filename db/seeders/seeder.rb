class Seeder
  def self.comp_start
    case ENV['STAGE']
    when 'PRE_CONNECTION'
      Time.now + 2.months
    when 'MID_COMPETITION'
      Time.now - 1.days
    when 'POST_COMPETITION'
      Time.now - 4.days
    when 'MID_JUDGING'
      Time.now - 1.weeks - 4.days
    when 'POST_JUDGING'
      Time.now - 4.weeks
    when 'POST_AWARDS'
      Time.now - 5.weeks
    else
      Time.now
    end
  end

  def self.random_boolean
    [true, false].sample
  end
end
