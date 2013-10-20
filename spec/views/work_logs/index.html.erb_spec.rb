require 'spec_helper'

describe "work_logs/index" do
  before(:each) do
    assign(:work_logs, [
      stub_model(WorkLog,
        :issue_id => 1,
        :user_id => 2
      ),
      stub_model(WorkLog,
        :issue_id => 1,
        :user_id => 2
      )
    ])
  end

  it "renders a list of work_logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
