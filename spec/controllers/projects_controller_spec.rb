require 'spec_helper'

describe ProjectsController do
  before do
    @user = create(:user)
    sign_in @user
  end

  describe "GET 'show'" do
    before do
      @project = create(:public_active_project)
    end

    it "returns http status ok" do
      get 'show', id: @project.to_param
      expect(response).to be_ok
    end

    it "renders template 'show'" do
      get 'show', id: @project.to_param
      expect(response).to render_template 'show'
    end
  end

  describe "GET 'new'" do
    it "returns http status ok" do
      get 'new'
      expect(response).to be_ok
    end

    it "renders template 'new'" do
      get 'new'
      expect(response).to render_template 'new'
    end
  end
  
  describe "POST 'create'" do
    context "with valid params" do
      it "redirects to project" do
        post 'create', project: attributes_for(:public_active_project)
        expect(response).to redirect_to Project.last
      end

      it "creates a project" do
        expect {
          post 'create', project: attributes_for(:public_active_project)
        }.to change(Project, :count).by(1)
      end
    end

    context "with invalud params" do
      it "renders template 'new'" do
        post 'create', project: attributes_for(:public_active_project, name: nil)
        expect(response).to render_template 'new'
      end
    end
  end

  describe "PUT/PATCH 'update'" do
    before do
      @project = create(:public_active_project, name: "Project")
      @project.members.create(user: @user, is_admin: true)
      @name = "Name cahnges"
    end

    context "with valid params" do
      it "redirects to project" do
        patch 'update', id: @project.to_param, project: { name: @name }
        expect(response).to redirect_to @project
      end

      it "updates a project" do
        patch 'update', id: @project.to_param, project: { name: @name }
        @project.reload
        expect(@project.name).to eq(@name)
      end
    end

    context "with invalid params" do
      it "renders template 'edit'" do
        patch 'update', id: @project.to_param, project: { name: nil }
        expect(response).to render_template 'edit'
      end
    end
  end
end
