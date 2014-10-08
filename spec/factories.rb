FactoryGirl.define do
  factory :comment_github do
    name "github"
    foreign_id 1
    provided_type "Comment"
    info ""
    provided_id 1
  end
end
