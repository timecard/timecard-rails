require "spec_helper"

describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  describe "CanCan::AccessDenied" do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    it "redirects to root url when requested html" do
      get :index
      expect(response).to redirect_to("/")
    end

    it "responses unauthorized and returns empty array json when requested html" do
      get :index, format: :json
      expect(response.status).to eq(401)
      expect(response.body).to eq("[]")
    end
  end

  describe "#user_work_in_progress" do
    it "returns false unless user signed in" do
      get :index
      expect(@controller.send(:user_work_in_progress?)).to be_false
    end

    context "when user signed in" do
      before do
        sign_in alice
      end

      it "returns false if current user isn't working" do
        get :index
        expect(@controller.send(:user_work_in_progress?)).to be_false
      end

      it "returns true if current user is working" do
        create(:work_in_progress, user: @controller.current_user)
        get :index
        expect(@controller.send(:user_work_in_progress?)).to be_true
      end
    end
  end
end
