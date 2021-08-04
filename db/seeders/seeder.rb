class Seeder
  def self.competition_start
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

  def self.random_tags
    rand(0..15).times.map { Faker::Hacker.adjective }.uniq
  end

  def self.random_skills
    rand(0..5).times.map { Faker::Job.key_skill }.uniq
  end

  def self.random_interests
    rand(0..5).times.map { Faker::Hacker.ingverb }.uniq
  end

  def self.admin_email
    ENV['SEED_EMAIL'] || 'admin@hackerspace.com'
  end

  def self.admin_name
    ENV['SEED_NAME'] || 'Admin User'
  end
end
