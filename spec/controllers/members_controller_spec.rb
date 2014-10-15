require 'rails_helper'

describe MembersController do
  before do
    @alice = create(:alice)
    sign_in @alice
    @project = create(:project)
  end

  describe "GET search" do
    it "returns status success" do
      create(:member, project: @project, user: @alice, is_admin: true)
      get :search, format: :json, project_id: @project.id, q: "query"
      expect(response).to be_success
    end
  end

  describe "PATCH update" do
    it "updates member" do
      user = create(:user)
      create(:member, project: @project, user: @alice, is_admin: true, role: 0)
      member = create(:member, project: @project, user: user, is_admin: false, role: 2)
      xhr :patch, :update, id: member.id, member: { role: 1 }
      member.reload
      expect(member.role).to eq(1)
    end
  end
end
