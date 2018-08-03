class User < ApplicationRecord
  # Devise options
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  has_many :assignments, dependent: :destroy

  # Gravitar Gem
  include Gravtastic
  has_gravatar

  # Active Storage prifel image.
  has_one_attached :govhack_img

  def admin_privileges?
    return true unless (assignments.pluck(:title) & COMP_ADMIN).empty?
  end

  def admin_assignments
    assignments.where(title: ADMIN_TITLES)
  end

  def make_site_admin
    Competition.current.assignments.find_or_create_by(user: self, title: ADMIN)
  end

  def display_name
    return preferred_name unless preferred_name.nil? || preferred_name.empty?
    full_name
  end

  def event_assignment
    assignment = Competition.current.assignments.find_by(user: self, title: VIP)
    return assignment unless assignment.nil?
    Competition.current.assignments.find_or_create_by(user: self, title: PARTICIPANT)
  end

  def registrations
    event_assignment.registrations
  end

  def self.search(term)
    results = []
    User.all.each do |user|
      user_string = "#{user.full_name} #{user.email} #{user.preferred_name}"
      results << user if user_string.include? term.downcase
    end
    results
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by_email(data['email'])
    user ||= new_user_from_google(data)
    user.skip_confirmation_notification!
    update_user_info_from_google(user, data)
    user.save
    user
  end

  def no_dietary_requirements?
    dietary_requirements.nil? || dietary_requirements.empty?
  end

  def registering_account?
    how_did_you_hear.nil? || how_did_you_hear.empty?
  end

  def self.new_user_from_google(data)
    User.new(full_name: data['name'],
             email: data['email'],
             password: Devise.friendly_token[0, 20])
  end

  def self.update_user_info_from_google(user, data)
    user.update(google_img: data['image'])
    return unless user.full_name.nil? || user.full_name.empty?
    user.update(full_name: data['name'])
  end
end
