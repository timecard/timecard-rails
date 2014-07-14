FactoryGirl.define do
  factory :authentication do
    user
    provider "Github"
    uid 1
    username "MyString"
    oauth_token SecureRandom.hex(16)
  end

  factory :github, class: Authentication do
    user
    provider "github"
    uid 1
    username "github"
    oauth_token SecureRandom.hex(16)
  end
end
