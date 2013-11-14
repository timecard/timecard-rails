require 'spec_helper'

describe WorkloadsController do
  before do
    @user = create(:user)
    @issue = create(:issue)
    sign_in @user
  end

  describe "PATCH 'update'" do
    describe "with valid params" do
      it "redirects to issue url" do
        workload = create(:workload)
        patch 'update', id: workload.to_param, workload: attributes_for(:workload)
        expect(response).to redirect_to workload.issue
      end
    end

    describe "with invalid params" do
      it "renders template edit" do
        workload = create(:workload)
        patch 'update', id: workload.to_param, workload: attributes_for(:workload, start_at: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "changes Issue count by -1" do
      workload = create(:workload)
      expect {
        delete 'destroy', id: workload.to_param
      }.to change(Workload, :count).by(-1)
    end

    it "redirects to issue url" do
      workload = create(:workload)
      delete 'destroy', id: workload.to_param
      expect(response).to redirect_to workload.issue
    end
  end

  describe "POST 'start'" do
    it "creates new workload" do
      expect {
        post 'start', issue_id: @issue, workload: attributes_for(:workload)
      }.to change(Workload, :count).by(1)
    end

    describe "if other issue already running" do
      it "stop prev issue and start new issue" do
        workload = create(:workload, user: @user, issue_id: @issue.id+1, end_at: nil)
        post 'start', issue_id: @issue, workload: attributes_for(:workload)
        workload.reload
        expect(workload.end_at).not_to be_nil
      end
    end
  end

  describe "PATCH 'stop'" do
    it "inserts time to end_at" do
      post 'start', issue_id: @issue, workload: attributes_for(:workload)
      expect(Workload.last.end_at).to be_nil
      patch 'stop', id: Workload.last
      expect(Workload.last.end_at).not_to be_nil
    end
  end
end
