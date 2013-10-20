require 'spec_helper'

describe "issues/index" do
  before(:each) do
    assign(:issues, [
      stub_model(Issue,
        :subject => "Subject",
        :description => "MyText",
        :integer => "Integer",
        :project_id => 1,
        :author_id => 2,
        :assignee_id => 3
      ),
      stub_model(Issue,
        :subject => "Subject",
        :description => "MyText",
        :integer => "Integer",
        :project_id => 1,
        :author_id => 2,
        :assignee_id => 3
      )
    ])
  end

  it "renders a list of issues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Integer".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
