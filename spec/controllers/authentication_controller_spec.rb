require "rails_helper"

describe AuthenticationsController do
  describe "GET 'index'" do
    it "renders template 'index'" do
      alice = create(:alice)
      sign_in alice
      get :index, user_id: alice.id
      expect(response).to render_template "index"
    end
  end

  describe "GET 'new'" do
    it "renders template 'new'" do
      alice = create(:alice)
      sign_in alice
      get :new, user_id: alice.id
      expect(response).to render_template "new"
    end
  end

  describe "POST 'create'" do
    it "creates a authentication" do
      alice = create(:alice)
      sign_in alice
      expect {
        post :create, user_id: alice.id, authentication: attributes_for(:authentication)
      }.to change(Authentication, :count).by(1)
    end

    it "renders template 'new' if validate false" do
      alice = create(:alice)
      sign_in alice
      post :create, user_id: alice.id, authentication: attributes_for(:authentication, username: nil)
      expect(response).to render_template "new"
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes a authentication" do
      alice = create(:alice)
      sign_in alice
      authentication = create(:authentication, user: alice)
      expect {
        delete :destroy, user_id: alice.id, id: authentication.id
      }.to change(Authentication, :count).by(-1)
    end
  end
end
