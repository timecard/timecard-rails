# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_log do
    start_at "2013-10-01 16:06:34"
    end_at "2013-10-01 16:06:34"
    issue_id 1
    user_id 1
  end
end
