require 'rails_helper'

describe MembersController do
  describe "GET search" do
    it "returns status success" do
      alice = create(:alice)
      sign_in alice
      project = create(:project)
      create(:member, project: project, user: alice, is_admin: true)
      get :search, format: :json, project_id: project.id, q: "query"
      expect(response).to be_success
    end
  end
end
