# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "MyString"
    description "MyText"
    is_public false
    parent_id 1
    status 1
  end
end
