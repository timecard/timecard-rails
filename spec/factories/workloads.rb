FactoryGirl.define do
  factory :work_in_progress, class: "Workload" do
    start_at "2013-10-01 16:06:34"
    end_at nil
    issue
    user
  end

  factory :workload do
    start_at "2013-10-01 16:06:34"
    end_at "2013-10-01 16:06:34"
    issue
    user
  end
end
