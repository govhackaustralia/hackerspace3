class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(preferred_name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20],
                         google_img: data['image'])
    user
  end
end
