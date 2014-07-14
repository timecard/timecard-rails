require "spec_helper"

describe GithubMediator do
  before do
    @user = create(:user)
    @github = create(:github, user: @user)
    @issue_params = ActionController::Parameters.new(attributes_for(:issue, author_id: @user.id, assignee_id: @user.id, github_labels: { "0" => "bug", "1" => "enchanced"}))
    full_name = "rails/rails"
    @mediator = GithubMediator.new(@github.oauth_token, full_name)
  end

  context "public method" do
    describe "#create_issue" do
      pending
    end
  end

  context "private method" do
    describe "#issue_options_from_params" do
      it "should returns github issue options" do
        labels = @issue_params[:github_labels].map do |key, value|
          value
        end
        options = @mediator.send(:issue_options_from_params, @issue_params)
        expect(options["title"]).to eq(@issue_params["subject"])
        expect(options["body"]).to eq(@issue_params["description"])
        expect(options["state"]).to eq("open")
        expect(options["assignee"]).to eq(@github.username)
        expect(options["labels"]).to eq(labels)
      end
    end
  end
end
