require 'spec_helper'

describe Comment do
  describe "#github" do
    it "should be return CommentGithub" do
      comment = create(:comment)
      comment.add_github(1)
      expect(comment.github.class).to be(CommentGithub)
    end
  end

  describe "#add_github" do
    describe "with valid params" do
      it "should be return true" do
        comment = create(:comment)
        expect(comment.add_github(1)).to be_true
      end
    end
  end
end
