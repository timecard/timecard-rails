require 'rails_helper'

describe IssuesController do

  describe "logged in" do
    before do
      @user = create(:user)
      @project = create(:project)
      sign_in @user
    end

    describe "GET 'index'" do
      context "as json" do
        it "returns http status ok" do
          project = create(:public_active_project)
          get 'index', project_id: project.to_param, format: :json
          expect(response).to be_ok
        end

        it "assigns to project issues as @issues" do
          project = create(:public_active_project)
          issue = create(:issue, project: project)
          get 'index', project_id: project.to_param, format: :json
          expect(assigns(:issues)).to eq([issue])
        end

        context "with user_id" do
          it "returns http status ok" do
            project = create(:public_active_project)
            get 'index', project_id: project.to_param, user_id: @user.to_param, format: :json
            expect(response).to be_ok
          end

          it "assigns to user issues as @issues" do
            project = create(:public_active_project)
            issue = create(:issue, project: project, assignee: @user)
            get 'index', project_id: project.to_param, user_id: @user.to_param, format: :json
            expect(assigns(:issues)).to eq([issue])
          end
        end

        context "when the project is private and user is not member" do
          it "returns http status unauthorized" do
            project = create(:private_active_project)
            get 'index', project_id: project.to_param, format: :json
            expect(response.status).to eq(401)
          end
        end
      end
    end

    describe "GET show" do
      it "assigns the requested issue as @issue" do
        issue = create(:issue, project: @project)
        get :show, id: issue.to_param
        expect(assigns(:issue)).to eq(issue)
      end
    end

    describe "GET new" do
      describe "when the user is project member" do
        before do
          create(:member, user: @user, project: @project)
        end

        it "assigns a new issue as @issue" do
          get :new, project_id: @project
          expect(assigns(:issue)).to be_a_new(Issue)
        end
      end

      context "when the project is private and user is not project member" do
        it "redirects to root_url" do
          get :new, project_id: @project
          expect(response).to redirect_to root_url
        end
      end
    end

    describe "GET edit" do
      pending
    end

    describe "POST create" do
      pending
    end

    describe "PUT update" do
      pending
    end

    describe "PATCH close" do
      context "when the user is project member" do
        before do
          create(:member, user: @user, project: @project)
        end
        
        it "changes status from open to closed" do
          @issue = create(:issue, project: @project)
          patch :close, id: @issue.to_param
          @issue.reload
          expect(@issue.status).to eq(9)
        end

        context "work in progress the issue" do
          it "stops the workload" do
            @issue = create(:issue, project: @project)
            @workload = create(:workload, end_at: nil, user: @user, issue: @issue)
            patch :close, id: @issue.to_param
            @workload.reload
            expect(@workload.end_at).not_to be_nil
          end
        end
      end

      context "when the user is not project member" do
        it "redirects to root_url" do
          @issue = create(:issue, project: @project)
          patch :close, id: @issue.to_param
          expect(response).to redirect_to root_url
        end
      end
    end

    describe "PATCH reopen" do
      context "when the user is project member" do
        before do
          create(:member, user: @user, project: @project)
        end
        
        it "changes status from closed to open" do
          @issue = create(:issue, project: @project, status: 9)
          patch :reopen, id: @issue.to_param
          @issue.reload
          expect(@issue.status).to eq(1)
        end
      end

      describe "when the user is not project member" do
        it "redirects to root_url" do
          @issue = create(:issue, project: @project)
          patch :reopen, id: @issue.to_param
          expect(response).to redirect_to root_url
        end
      end
    end

    describe "PATCH postpone" do
      pending
    end

    describe "PATCH do_today" do
      pending
    end
  end
end
