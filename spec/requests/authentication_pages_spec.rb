require 'spec_helper'

describe "Authentication" do

  #let's test the page
  subject { page }

  describe "signin page" do
    # go to signin
    before { visit signin_path }

    # does it say what it should say?
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    #go to signin
    before { visit signin_path }

    #try an invalid signin
    describe "with invalid information" do
      before { click_button "Sign in" }

      #we should get the title and the error message
      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before {click_link "Home"}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        #click sign out
        before {click_link "Sign out"}
        #then we should see a signi n link
        it {should have_link ('Sign in')}
      end
    end
  end
end
