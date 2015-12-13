class User < ActiveRecord::Base
  before_create :init_tokens

  def self.authenticate(email, password)
    user = where('email = ? AND password = ?', email, password).first
  end
  
  def self.verify_token(token)
    user = where('verification_token = ?', token).first
    user.generate_verification_token
    user if user.save
  end

  def self.find_by_auth_token(auth_token)
    where('auth_token = ?', auth_token).first
  end

  def generate_verification_token
    generate_token :verification_token
  end

  # You should ensure this is unique. It's not in our implementation :)
  def generate_token attr
    self[attr] = SecureRandom.urlsafe_base64
  end
  
  private

  def init_tokens
    generate_token :user_id
    generate_token :auth_token
    generate_token :verification_token
  end
end