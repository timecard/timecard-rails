require 'rails_helper'

describe UsersController do
  before do
    @user = create(:user)
  end

  describe "Logged in"do
    before do
      sign_in @user
    end

    describe "GET 'show'" do
      it "returns http status success" do
        get 'show', id: @user.to_param
        expect(response).to be_success
      end

      it "renders template show" do
        get 'show', id: @user.to_param
        expect(response).to render_template 'show'
      end

      it "assigns to user as @user" do
        get 'show', id: @user.to_param
        expect(assigns[:user]).to eq(@user)
      end
    end
  end

  describe "Not Logged in" do
    describe "GET 'show'" do
      it "returns http status redirect" do
        get 'show', id: @user.to_param
        expect(response).to be_redirect
      end

      it "redirects to new user session url" do
        get 'show', id: @user.to_param
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "Logged in via Github" do
    before do
      auth = create(:authentication, user: @user)
      sign_in @user
    end

    describe "DELETE 'disconnect'" do
      it "returns http status redirect" do
        delete 'disconnect', provider: 'Github'
        expect(response).to be_redirect
      end

      it "redirects to edit user registration url" do
        delete 'disconnect', provider: 'Github'
        expect(response).to redirect_to edit_user_registration_url
      end

      it "changes Authentication count by -1" do
        expect {
          delete 'disconnect', provider: 'Github'
        }.to change(Authentication, :count).by(-1)
      end
    end
  end
end
