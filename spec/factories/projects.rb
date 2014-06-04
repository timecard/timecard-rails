FactoryGirl.define do
  factory :project do
    name "MyString"
    description "MyText"
    is_public false
    parent_id 1
    status 1
  end

  factory :private_active_project, class: :project do
    name "Private Active Project"
    description "MyText"
    is_public false
    parent_id 1
    status Project::STATUS_ACTIVE
  end

  factory :public_active_project, class: :project do
    name "Private Active Project"
    description "MyText"
    is_public true
    parent_id 1
    status Project::STATUS_ACTIVE
  end
end
