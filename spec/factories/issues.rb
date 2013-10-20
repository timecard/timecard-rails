# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issue do
    subject "MyString"
    description "MyText"
    start_date "2013-09-30 22:53:40"
    integer "MyString"
    closed_on "2013-09-30 22:53:40"
    project_id 1
    author_id 1
    assignee_id 1
  end
end
