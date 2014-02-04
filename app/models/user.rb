class User < ActiveRecord::Base

  #force email to lowercase to help with uniqueness validations
  before_save { self.email = email.downcase }

  #validates that name is present, pretty simple
  validates(:name, presence: true, length: {maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #"validates: uniqueness" does not guarantee uniqueness.  There is still the db level
  #where things can get out of whack with race conditions on save()
  validates(:email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false})

  #all the stuff for password
  has_secure_password
  validates(:password, length: {minimum: 6})
end
