require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  before do
    @alice = create(:alice)
    sign_in @alice
    @project = create(:project)
    create(:member, user: @alice, project: @project)
    @issue = create(:issue, project: @project)
  end

  describe "POST 'create'" do
    it "creates a new comment" do
      expect {
        post :create, comment: attributes_for(:comment), issue_id: @issue.id
      }.to change(Comment, :count).by(1)
    end
  end

  describe "PATCH 'update'" do
    before do
      @comment = create(:comment, issue: @issue, user: @alice)
      @original_body = @comment.body
      @changed_body = "Changed!"
    end

    it "updates a comment" do
      patch :update, id: @comment.id, comment: { body: @changed_body }
      @comment.reload
      expect(@comment.body).to eq(@changed_body)
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @comment = create(:comment, issue: @issue, user: @alice)
    end

    it "deletes a comment" do
      expect {
        delete :destroy, id: @comment.id
      }.to change(Comment, :count).by(-1)
    end
  end
end
