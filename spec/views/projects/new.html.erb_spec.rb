require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :name => "MyString",
      :description => "MyText",
      :is_public => false,
      :parent_id => 1,
      :status => 1
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projects_path, "post" do
      assert_select "input#project_name[name=?]", "project[name]"
      assert_select "textarea#project_description[name=?]", "project[description]"
      assert_select "input#project_is_public[name=?]", "project[is_public]"
      assert_select "input#project_parent_id[name=?]", "project[parent_id]"
      assert_select "input#project_status[name=?]", "project[status]"
    end
  end
end
