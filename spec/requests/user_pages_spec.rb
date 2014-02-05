require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    # FactoryGirl creates a user for us from the
    # definitions in factories.rb
    # This is a quick way to create test data for your tests.
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit}

        it {should have_title(full_title('Sign up')) }
        it {should have_content('error')}
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        # try to find the user we just created
        let(:user) { User.find_by(email: 'user@example.com') }

        # verify that the page has the correct user information
        # does the name match?
        it { should have_title(user.name) }
        # did the page say success?
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
