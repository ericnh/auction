class User < ActiveRecord::Base
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  
  before_save { email.downcase! }
end
