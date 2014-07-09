require 'spec_helper'

describe WorkloadsController do
  before do
    @user = create(:user)
    create(:authentication, provider: 'chatwork', user: @user)
    @project = create(:project)
    create(:member, project: @project, user: @user)
    @issue = create(:issue, project: @project)
    @previous_issue = create(:issue, project: @project)
    sign_in @user

    Chatwork.stub(:post)
  end

  describe "GET 'index'" do
    context "includes user" do
      context "not include date" do
        it "returns http status ok" do
          get 'index', user_id: @user.id, format: :json
          expect(response).to be_ok
        end

        it "renders template 'index'" do
          get 'index', user_id: @user.id, format: :json
          expect(response).to render_template 'index'
        end

        it "assigns to all own workloads as @workloads" do
          workload = create(:workload, user: @user)
          get 'index', user_id: @user.id, format: :json
          expect(assigns[:workloads]).to eq([workload])
        end
      end

      context "includes year, month and day" do
        let(:today) { Date.today }
        it "returns http status ok" do
          get 'index', user_id: @user.id, year: today.year, month: today.month, day: today.day, format: :json
          expect(response).to be_ok
        end

        it "renders template 'index'" do
          get 'index', user_id: @user.id, year: today.year, month: today.month, day: today.day, format: :json
          expect(response).to render_template 'index'
        end
      end
    end
  end

  describe "POST 'create'" do
    it "creates new workload" do
      expect {
        post "create", issue_id: @issue, workload: attributes_for(:workload)
      }.to change(Workload, :count).by(1)
    end

    describe "if other issue already running" do
      it "stop previous issue and start new issue" do
        workload = create(:workload, user: @user, issue: @previous_issue, end_at: nil)
        post 'create', issue_id: @issue, workload: attributes_for(:workload)
        workload.reload
        expect(workload.end_at).not_to be_nil
      end
    end
  end

  describe "PATCH 'update'" do
    describe "with valid params" do
      it "redirects to issue url" do
        workload = create(:workload, issue: @issue, user: @user)
        patch 'update', id: workload.to_param, workload: attributes_for(:workload)
        expect(response).to redirect_to workload.issue
      end
    end

    describe "with invalid params" do
      it "renders template edit" do
        workload = create(:workload, issue: @issue, user: @user)
        patch 'update', id: workload.to_param, workload: attributes_for(:workload, start_at: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "changes Issue count by -1" do
      workload = create(:workload, issue: @issue, user: @user)
      expect {
        delete 'destroy', id: workload.to_param
      }.to change(Workload, :count).by(-1)
    end

    it "redirects to issue url" do
      workload = create(:workload, issue: @issue, user: @user)
      delete 'destroy', id: workload.to_param
      expect(response).to redirect_to workload.issue
    end
  end

  describe "PATCH 'stop'" do
    it "inserts time to end_at" do
      post 'create', issue_id: @issue, workload: attributes_for(:workload)
      expect(Workload.last.end_at).to be_nil
      patch 'stop', id: Workload.last
      expect(Workload.last.end_at).not_to be_nil
    end
  end
end
