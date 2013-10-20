require 'spec_helper'

describe "issues/edit" do
  before(:each) do
    @issue = assign(:issue, stub_model(Issue,
      :subject => "MyString",
      :description => "MyText",
      :integer => "MyString",
      :project_id => 1,
      :author_id => 1,
      :assignee_id => 1
    ))
  end

  it "renders the edit issue form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", issue_path(@issue), "post" do
      assert_select "input#issue_subject[name=?]", "issue[subject]"
      assert_select "textarea#issue_description[name=?]", "issue[description]"
      assert_select "input#issue_integer[name=?]", "issue[integer]"
      assert_select "input#issue_project_id[name=?]", "issue[project_id]"
      assert_select "input#issue_author_id[name=?]", "issue[author_id]"
      assert_select "input#issue_assignee_id[name=?]", "issue[assignee_id]"
    end
  end
end
