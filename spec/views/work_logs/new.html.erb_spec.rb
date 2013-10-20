require 'spec_helper'

describe "work_logs/new" do
  before(:each) do
    assign(:work_log, stub_model(WorkLog,
      :issue_id => 1,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new work_log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_logs_path, "post" do
      assert_select "input#work_log_issue_id[name=?]", "work_log[issue_id]"
      assert_select "input#work_log_user_id[name=?]", "work_log[user_id]"
    end
  end
end
