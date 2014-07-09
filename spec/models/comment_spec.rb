require 'spec_helper'

describe Comment do
  before do
    @project = create(:project)
    @issue = create(:issue)
  end

  describe "#github" do
    it "should be return CommentGithub" do
      comment = create(:comment, issue: @issue)
      comment.add_github(1)
      expect(comment.github.class).to be(CommentGithub)
    end
  end

  describe "#add_github" do
    describe "with valid params" do
      it "should be return true" do
        comment = create(:comment, issue: @issue)
        expect(comment.add_github(1)).to be_true
      end
    end
  end
end
