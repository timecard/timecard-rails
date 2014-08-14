require "rails_helper"

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

  describe "#current_user_time_tracking" do
    context "not sign in user" do
      it "returns false" do
        get :index
        expect(@controller.send(:current_user_time_tracking?)).to eq(false)
      end
    end

    context "sign in user" do
      before do
        sign_in alice
      end

      it "returns false if current user isn't time tracking" do
        get :index
        expect(@controller.send(:current_user_time_tracking?)).to eq(false)
      end

      it "returns true if current user is time tracking" do
        create(:work_in_progress, user: @controller.current_user)
        get :index
        expect(@controller.send(:current_user_time_tracking?)).to eq(true)
      end
    end
  end
end
