FactoryGirl.define do
  factory :issue_github do
    name "github"
    foreign_id 1
    provided_id 1
    provided_type "Issue"
    info HashWithIndifferentAccess.new({
      issue_id: 1,
      html_url: "https://github.com/rails/rails",
      number: 1,
      assignee_avatar_url: "",
      labels: ["bug", "feature", "enchanced"]
    })
  end
end
