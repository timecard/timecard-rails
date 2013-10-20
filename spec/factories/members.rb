# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    user_id 1
    project_id 1
    is_admin false
  end
end
