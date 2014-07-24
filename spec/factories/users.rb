FactoryGirl.define do
  factory :alice, class: "User" do
    email "alice@timecard.com"
    password Devise.friendly_token[0,20]
    password_confirmation { password }
    name "alice"
  end

  factory :user do
    sequence(:email) { |n| "timecard#{n}@timecard.com" }
    password Devise.friendly_token[0,20]
    password_confirmation { password }
    sequence(:name) { |n| "timecard#{n}" }
  end
end
