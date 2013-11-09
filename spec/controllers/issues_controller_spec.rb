require 'spec_helper'

describe IssuesController do

  describe "logged in" do
    describe "GET show" do
      before do
        @user = create(:user)
        @project = create(:project)
        sign_in @user
      end

      it "assigns the requested issue as @issue" do
        issue = create(:issue, project: @project)
        get :show, id: issue.to_param
        expect(assigns(:issue)).to eq(issue)
      end
    end

    describe "GET new" do
      before do
        @user = create(:user)
        @project = create(:project)
        sign_in @user
      end

      describe "if user is project member" do
        before do
          create(:member, user: @user, project: @project)
        end

        it "assigns a new issue as @issue" do
          get :new, project_id: @project
          expect(assigns(:issue)).to be_a_new(Issue)
        end
      end

      describe "if user is not project member" do
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
      before do
        @user = create(:user)
        @project = create(:project)
        sign_in @user
      end

      describe "if user is project member" do
        before do
          create(:member, user: @user, project: @project)
        end
        
        it "changes status from open to closed" do
          @issue = create(:issue, project: @project)
          patch :close, id: @issue.to_param
          @issue.reload
          expect(@issue.status).to eq(9)
        end
      end

      describe "if user is not project member" do
        it "redirects to root_url" do
          @issue = create(:issue, project: @project)
          patch :close, id: @issue.to_param
          expect(response).to redirect_to root_url
        end
      end
    end

    describe "PATCH reopen" do
      before do
        @user = create(:user)
        @project = create(:project)
        sign_in @user
      end

      describe "if user is project member" do
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

      describe "if user is not project member" do
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
