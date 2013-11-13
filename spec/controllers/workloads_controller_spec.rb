require 'spec_helper'

describe WorkloadsController do
  before do
    @user = create(:user)
    sign_in @user
  end

  describe "POST 'start'" do
    it "creates new workload" do
      issue = create(:issue)
      expect {
        post 'start', issue_id: issue, workload: attributes_for(:workload)
      }.to change(Workload, :count).by(1)
    end
  end

  describe "PATCH 'stop'" do
    it "inserts time to end_at" do
      issue = create(:issue)
      post 'start', issue_id: issue, workload: attributes_for(:workload)
      expect(Workload.last.end_at).to be_nil
      patch 'stop', id: Workload.last
      expect(Workload.last.end_at).not_to be_nil
    end
  end
end
