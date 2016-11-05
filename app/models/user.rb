class User < ActiveRecord::Base
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  
  before_save { email.downcase! }

  def User.digest(password_string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(password_string, cost: cost)
  end
end
