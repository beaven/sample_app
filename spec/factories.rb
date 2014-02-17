FactoryGirl.define do
  #create a regular user
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    #create an admin user
    factory :admin do
      admin true
    end
  end
end