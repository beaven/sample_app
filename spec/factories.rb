FactoryGirl.define do
  factory :user do
    name     "Damon Beaven"
    email    "beaven@lexmark.com"
    password "foobar"
    password_confirmation "foobar"
  end
end