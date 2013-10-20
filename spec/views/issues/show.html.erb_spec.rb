require 'spec_helper'

describe "issues/show" do
  before(:each) do
    @issue = assign(:issue, stub_model(Issue,
      :subject => "Subject",
      :description => "MyText",
      :integer => "Integer",
      :project_id => 1,
      :author_id => 2,
      :assignee_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Subject/)
    rendered.should match(/MyText/)
    rendered.should match(/Integer/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
