require "rails_helper"

RSpec.describe CommentGithub, type: :model do
  describe "#comment" do
    it "returns a comment" do
      project = create(:project)
      issue = create(:issue)
      comment = create(:comment, issue: issue)
      comment_github = create(:comment_github, foreign_id: comment.id)
      expect(comment_github.comment).to eq(comment)
    end
  end
end
