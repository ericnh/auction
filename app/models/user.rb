class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  
  before_save :downcase_email
  before_create :create_activation_digest

  def User.digest(secret_string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(secret_string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attributes(
      activated: true,
      activated_at: Time.zone.now
    )
  end

  def not_activated?
    !activated?
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    self.email.downcase!
  end
end
