require 'rails_helper'

describe User do
  before do
    @user = create(:user)
  end

  describe "#work_in_progress?" do
    context "with working issue" do
      it "returns true" do
        issue = create(:issue, author: @user, assignee: @user)
        workload = create(:workload, user: @user, issue: issue, end_at: nil)
        expect(@user).to be_work_in_progress(issue)
      end
    end

    context "with not working issue" do
      it "returns false" do
        issue = create(:issue, author: @user, assignee: @user)
        other_issue = create(:issue)
        workload = create(:workload, user: @user, issue: issue, end_at: nil)
        expect(@user).not_to be_work_in_progress(other_issue)
      end
    end
  end

  describe "#working_issue" do
    context "work in progress" do
      it "returns working the issue" do
        issue = create(:issue, author: @user, assignee: @user)
        workload = create(:workload, user: @user, issue: issue, end_at: nil)
        expect(@user.working_issue).to eq(issue)
      end
    end

    context "not work" do
      it "returns nil" do
        issue = create(:issue, author: @user, assignee: @user)
        workload = create(:workload, user: @user, issue: issue, end_at: Time.now.utc)
        expect(@user.working_issue).to be_nil
      end
    end
  end

  describe "#running_workload" do
    context "work in progress" do
      it "returns running workload" do
        issue = create(:issue, author: @user, assignee: @user)
        workload = create(:workload, user: @user, issue: issue, end_at: nil)
        expect(@user.running_workload).to eq(workload)
      end
    end

    context "not work" do
      it "returns nil" do
        issue = create(:issue, author: @user, assignee: @user)
        workload = create(:workload, user: @user, issue: issue, end_at: Time.now.utc)
        expect(@user.running_workload).to be_nil
      end
    end
  end
end
