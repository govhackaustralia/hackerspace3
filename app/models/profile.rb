class Profile < ApplicationRecord
  belongs_to :user

  has_one :employment_status, dependent: :destroy, inverse_of: :profile
  accepts_nested_attributes_for :employment_status

  validates :identifier, uniqueness: true, allow_nil: true

  validate :accept_code_of_conduct_before_publish

  acts_as_taggable_on :skills, :interests

  has_one_attached :profile_picture

  scope :published, -> { where published: true }

  def to_param
    identifier
  end

  after_create_commit :update_identifier

  enum first_peoples: {
    'No' => 0,
    'Yes, Aboriginal' => 1,
    'Yes, Torres Strait Islander' => 2,
    'Prefer not to say' => 3
  }

  enum disability: {
    'Yes' => 0,
    'No' => 1,
    'Prefer not to say' => 2
  }, _suffix: true

  enum education: {
    'Less that Year 12 or equivalent' => 0,
    'Year 12 or equivalent' => 1,
    'Vocational Qualification' => 2,
    'Associate diploma' => 3,
    'Undergraduate diploma' => 4,
    'Bachelor degree (including honours)' => 5,
    'Postgraduate diploma (includes graduate certificate)' => 6,
    "Master's degree" => 7,
    'Doctorate' => 8,
    'Prefer not to say' => 9
  }, _prefix: true

  enum age: {
    'Under 18' => 0,
    '18-24 years old' => 1,
    '25-34 years old' => 2,
    '35-44 years old' => 3,
    '45-54 years old' => 4,
    '55-64 years old' => 5,
    '64-75 years old' => 6,
    '75 years and older' => 7,
    'Prefer not to say' => 8
  }, _prefix: true

  enum team_status: {
    'Looking for a Team' => 0,
    'Looking for Team Mates' => 1,
    'Team Full' => 2,
    'In a Team' => 3
  }

  def update_identifier(identifier_name = nil)
    identifier_name ||= user.identifier_name

    return unless identifier_name.present?

    update_columns identifier: generate_identifier(identifier_name)
  end

  def generate_identifier(identifier_name)
    new_identifier = uri_pritty identifier_name

    return new_identifier unless Profile.where(identifier: new_identifier).where.not(id: id).exists?

    uri_pritty "#{new_identifier}-#{id}"
  end

  private

  def accept_code_of_conduct_before_publish
    return unless published

    return if user.accepted_code_of_conduct

    errors.add :user, 'please agree to the Code of Conduct'
  end
end
