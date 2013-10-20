require 'spec_helper'

describe "issues/new" do
  before(:each) do
    assign(:issue, stub_model(Issue,
      :subject => "MyString",
      :description => "MyText",
      :integer => "MyString",
      :project_id => 1,
      :author_id => 1,
      :assignee_id => 1
    ).as_new_record)
  end

  it "renders new issue form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", issues_path, "post" do
      assert_select "input#issue_subject[name=?]", "issue[subject]"
      assert_select "textarea#issue_description[name=?]", "issue[description]"
      assert_select "input#issue_integer[name=?]", "issue[integer]"
      assert_select "input#issue_project_id[name=?]", "issue[project_id]"
      assert_select "input#issue_author_id[name=?]", "issue[author_id]"
      assert_select "input#issue_assignee_id[name=?]", "issue[assignee_id]"
    end
  end
end
