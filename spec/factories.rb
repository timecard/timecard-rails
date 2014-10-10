FactoryGirl.define do
  factory :issue_ruffnote do
    name "ruffnote"
    foreign_id 1
    provided_type "Issue"
    info ""
    provided_id 1
  end

  factory :comment_github do
    name "github"
    foreign_id 1
    provided_type "Comment"
    info ""
    provided_id 1
  end
end
