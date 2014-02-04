require 'spec_helper'

describe User do

  #do this before all of these tests
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar" )
  end

  #this just means @user is the subject of the test and everything after this is relative to @user
  subject{ @user }

  #test for existence of proper columns in the user table
  it { should respond_to (:name) }
  it { should respond_to (:email) }
  it { should respond_to (:password_digest) }
  it { should respond_to (:password) }
  it { should respond_to (:password_confirmation) }
  it { should respond_to (:authenticate) }

  # sanity check, is the user valid
  it { should be_valid }

  # set user to blank and see that it fails
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      #create a duplicate user with the same attributes as @user
      user_with_same_email = @user.dup
      #make email all uppercase
      user_with_same_email.email = @user.email.upcase
      #save that dup user
      user_with_same_email.save
    end

    it {should_not be_valid}
  end

  describe "when password is not present" do
    before do
      # user with blank password
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    #check for invalid
    it { should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
    #force a password mismatch
    before { @user.password_confirmation = "mismatch"}
    #check for invalid
    it { should_not be_valid }
  end

  describe  "return value of authenticate method" do
    #save the user from above
    before { @user.save }
    #find the user by email
    let(:found_user) {User.find_by(email: @user.email)}

    #authenticate the user with it's own password
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end

    #authenticate the same user with "invalid" password
    describe "with invalid password" do
      #use invalid password
      let(:user_for_invalid_password) {found_user.authenticate("invalid")}

      it {should_not eq user_for_invalid_password}
      specify {expect(user_for_invalid_password).to be_false}
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it {should be_invalid}
  end
end
