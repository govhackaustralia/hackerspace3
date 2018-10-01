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

LAST_TIME_ZONE = 'Perth'
COMP_TIME_ZONE = 'Sydney'

# Assignment Permissions Framework Titles

## Competition Assignments

ADMIN = 'Admin'
MANAGEMENT_TEAM = 'GovHack Management Team'
COMPETITION_DIRECTOR = 'Competition Director'
SPONSORSHIP_DIRECTOR = 'Sponsorship Director'
CHIEF_JUDGE = 'Chief Judge'
VOLUNTEER = 'GovHack Volunteer'
VIP = 'VIP'
PARTICIPANT = 'Participant'

COMP_ADMIN = [MANAGEMENT_TEAM, ADMIN, COMPETITION_DIRECTOR]
EVENT_ASSIGNMENTS = [VIP, PARTICIPANT]
COMP_NON_ADMIN = [VIP, PARTICIPANT, VOLUNTEER]

## Region Assignments

REGION_DIRECTOR = 'Region Director'
REGION_SUPPORT = 'Region Support'

REGION_ADMIN = [REGION_DIRECTOR, REGION_SUPPORT]

REGION_PRIVILEGES = REGION_ADMIN + COMP_ADMIN

EVENT_HOST = 'Event Host'
EVENT_SUPPORT = 'Event Support'

## Sponsor Assignments

SPONSOR_CONTACT = 'Sponsor Contact'

SPONSOR_ADMIN = [SPONSOR_CONTACT, SPONSORSHIP_DIRECTOR]

SPONSOR_PRIVILEGES = [SPONSORSHIP_DIRECTOR, MANAGEMENT_TEAM, ADMIN,
                      REGION_DIRECTOR]

## Judge Assignments

JUDGE = 'Judge'

JUDGE_ADMIN = [CHIEF_JUDGE, JUDGE]

CRITERION_PRIVILEGES = [CHIEF_JUDGE] + COMP_ADMIN

## Event Assignments

EVENT_ADMIN = [EVENT_HOST, EVENT_SUPPORT]

EVENT_PRIVILEGES = EVENT_ADMIN + REGION_ADMIN + COMP_ADMIN

ADMIN_TITLES = COMP_ADMIN + REGION_ADMIN + EVENT_ADMIN

## TeamProject assignments

TEAM_LEADER = 'Team Leader'
TEAM_MEMBER = 'Team Member'
INVITEE = 'Invitee'

TEAM_ADMIN = [TEAM_LEADER, TEAM_MEMBER, INVITEE]

## Assignment Title Validation

VALID_ASSIGNMENT_TITLES = COMP_ADMIN + REGION_ADMIN + EVENT_ADMIN +
  COMP_NON_ADMIN + SPONSOR_ADMIN + TEAM_ADMIN + JUDGE_ADMIN

# Registration Statuses

ATTENDING = 'Attending'
NON_ATTENDING = 'Non Attending'
WAITLIST = 'Waitlist'

VALID_ATTENDANCE_STATUSES = [ATTENDING, NON_ATTENDING, WAITLIST]

# Images Preferences

GOVHACK = 'govhack_img'
GOOGLE = 'google_img'
GRAVITAR = 'gravitar_img'

VALID_IMAGE_OPTIONS = [GOVHACK, GOOGLE, GRAVITAR]

# T-shirt sizes

AVAILABLE_TSHIRT_SIZES = ['Small', 'Medium', 'Large']

# Event Types

CONNECTION_EVENT = 'Connection'
COMPETITION_EVENT = 'Competition'
AWARD_EVENT = 'Award'

EVENT_TYPES = [CONNECTION_EVENT, COMPETITION_EVENT, AWARD_EVENT]

# Competitions

MIN_CHALLENGE_ENTRY = 1

# Teams

MAX_TEAM_SIZE = 10

# Event Registration Types

OPEN = 'Open'
OPEN_AND_INVITATION = 'Open and Invitation'
INVITATION_ONLY = 'Invitation Only'
CLOSED = 'Closed'

EVENT_REGISTRATION_TYPES = [OPEN, OPEN_AND_INVITATION, INVITATION_ONLY, CLOSED]

# User Registration Types

COMPETITOR = 'Competitor'
YOUTH_COMPETITOR = 'Youth Competitor'
GUARDIAN_OBSERVER = 'Guardian / Observer'
SPONSOR_VIP_MEDIA = 'Sponsor / VIP / Media'

USER_REGISTRATION_TYPES = [COMPETITOR, YOUTH_COMPETITOR, GUARDIAN_OBSERVER,
                           SPONSOR_VIP_MEDIA]

# How did you hear about us no response placeholder

NO_RESPONSE = '[no response recorded]'

# Judgement Categories

PROJECT = 'Project'
CHALLENGE = 'Challenge'

JUDGEMENT_CATEGORIES = [PROJECT, CHALLENGE]

# Challenge Types

REGIONAL = 'Regional'
NATIONAL = 'National'

# Region Mailer Request Types

ALL = 'All'
NONE = 'None'
LEADER_ONLY = 'Leader Only'

MAIL_ORDER_REQUEST_TYPES = [ALL, NONE, LEADER_ONLY]
