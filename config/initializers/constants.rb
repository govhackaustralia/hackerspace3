# E-mail Regex
# Source: Michael Hartl Ruby on Rails Tutorial
# https://www.railstutorial.org/book/modeling_users

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

# General String Lengths
# Source: Old twitter tweet limit.
# Note: Increase as needed.

MAX_STRING_LENGTH = 140

# Twitter Handles
# Source: Help with Username Registration
# https://help.twitter.com/en/managing-your-account/twitter-username-rules

MAX_TWITTER_LENGTH = 15

# Competition Judgement Scores
# Source: Project Specification

MIN_SCORE = 1
MAX_SCORE = 10

# URL Limits
# Source: Stack Overflow
# https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers

MAX_URL_LENGTH = 2000

# Other Field Lengths
# Source: From the Ether :)
# Note: Increase as needed.

MAX_TEXT_LENGTH = 5000
MAX_LOCATION_NAME_LENGTH = 50
MAX_ATTENDANCE_CAPACITY = 200,000
MAX_FULL_NAME_LENGTH = 1000
PHONE_NUMBER_LENGTH = 10

# Maximum time attendee has before place is potentially lost to someone else.

MAX_DECISION_TIME = 2.minutes

# The default name for the root/national region.

ROOT_REGION_NAME = 'Australia'

# Australian Time Zones

VALID_TIME_ZONES = []

ActiveSupport::TimeZone.country_zones('AU').each do |zone|
  VALID_TIME_ZONES << zone.name
end

# Assignment Permissions Framework Titles

ADMIN = 'Admin'
MANAGEMENT_TEAM = 'GovHack Management Team'

REGION_DIRECTOR = 'Region Director'
REGION_SUPPORT = 'Region Support'

VALID_ADMIN_TITLES = [MANAGEMENT_TEAM, ADMIN]

VALID_ASSIGNMENT_TITLES = [REGION_DIRECTOR, REGION_SUPPORT] + VALID_ADMIN_TITLES
