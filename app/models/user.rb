class User < ActiveRecord::Base

  #force email to lowercase to help with uniqueness validations
  # ! functions modify the value in place (by convention)
  before_save { email.downcase! }
  #let's create that token before we create the object
  before_create :create_remember_token

  #validates that name is present, pretty simple
  validates(:name, presence: true, length: {maximum: 50})
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #"validates: uniqueness" does not guarantee uniqueness.  There is still the db level
  #where things can get out of whack with race conditions on save()
  validates(:email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false})

  #all the stuff for password
  has_secure_password
  validates(:password, length: {minimum: 6})

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
