FactoryGirl.define do
  factory :authentication do
    user
    provider "Github"
    uid 1
    username "MyString"
    oauth_token SecureRandom.hex(16)
  end
end
