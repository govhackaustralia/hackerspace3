class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  has_many :assignments

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(preferred_name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20],
                         google_img: data['image'])
    user
  end

  def admin_privileges?
    return true unless (assignments.pluck(:title) & VALID_ADMIN_TITLES).empty?
  end

  def make_site_admin
    Competition.current.assignments.create(user: self, title: ADMIN)
  end

  def make_management_team
    Competition.current.assignments.create(user: self, title: MANAGEMENT_TEAM)
  end
end
