require 'rails_helper'

describe MembersController do
  before do
    @alice = create(:alice)
    sign_in @alice
    @project = create(:project)
    @member = create(:member, project: @project, user: @alice, is_admin: true)
  end

  describe "GET 'index'" do
    it "renders template 'index'" do
      get :index, project_id: @project.id
      expect(response).to render_template "index"
    end

    it "renders template 'index'" do
      create(:authentication, provider: "github", user: @alice)
      get :index, project_id: @project.id, github: 1
      expect(response).to render_template "index"
    end
  end

  describe "POST 'create'" do
    it "creates a member" do
      user = create(:user)
      expect {
        post :create, project_id: @project.id, user_id: user.id
      }.to change(Member, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes a member" do
      user = create(:user)
      member = create(:member, project: @project, user: user)
      expect {
        delete :destroy, project_id: @project.id, id: member.id
      }.to change(Member, :count).by(-1)
    end
  end
end
