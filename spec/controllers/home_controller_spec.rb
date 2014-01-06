require 'spec_helper'

describe HomeController do
  context "Not Logged in" do
    describe "GET 'index'" do
      it "renders template 'welcome'" do
        get 'index'
        expect(response).to render_template 'welcome'
      end
    end
  end

  context "Logged in" do
    before do
      @user = create(:user)
      sign_in @user
    end

    describe "GET 'index'" do
      it "renders template 'index'" do
        get 'index'
        expect(response).to render_template 'index'
      end
    end
  end
end
