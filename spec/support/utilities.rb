include ApplicationHelper

#def full_title (page_title)
#  #let's create a title.  if we get a page_title we will add it to the full_title
#  #otherwise we just return the full_title.
#  base_title = "Ruby on Rails Tutorial Sample App"
#  if page_title.empty?
#    base_title
#  else
#    "#{base_title} | #{page_title}"
#  end
#end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

def welcome_page
  have_selector('div.alert.alert-success', text: 'Welcome')
end
