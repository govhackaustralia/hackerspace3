# This file should contain all the record creation needed to seed the database
# with its default values.

# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).

# To set to a particular a point in the competition run db:setup with the below
# STAGE variables set.

# PRE_CONNECTION - For before the connection events.
# MID_COMPETITION - For mid way through the competition.
# POST_COMPETITION - For After the competition.
# MID_JUDGING - For during competition judging.
# POST_JUDGING - For after competition judging.
# POST_AWARDS - For after awards events.

# Example $ rails db:setup STAGE=PRE_CONNECTION

# ENHANCEMENT: Add RegionLimit and Correspondence data

require_relative 'seeders/competition_seeder'
require_relative 'seeders/user_seeder'

UserSeeder.create_tester
# Create Competitions for all years since 2018
(2018-Time.now.year..0).each do |offset|
  UserSeeder.create_users 100/(offset.abs + 1)
  CompetitionSeeder.create offset
end
