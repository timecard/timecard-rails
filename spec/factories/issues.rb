FactoryGirl.define do
  factory :issue do
    subject "MyString"
    description "MyText"
    will_start_at "2013-09-30 22:53:40"
    status 1
    closed_on "2013-09-30 22:53:40"
    project_id 1
    author_id 1
    assignee_id 1
  end
end
