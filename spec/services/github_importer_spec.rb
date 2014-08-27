require "rails_helper"

RSpec.describe GithubImporter do
  before do
    @project = create(:project)
    @alice = create(:alice)
    @github = create(:github, user: @alice)
    create(:member, project: @project, user: @alice, is_admin: true)
    @project.add_github("rails/rails", false)
  end

  describe "#import_issue" do
    before do
      @github_issue = Hashie::Mash.new({
        title: "Example issue",
        description: "Issue description",
        state: "open",
        number: "123",
        user: {
          id: @alice.github.uid,
          login: @alice.github.username
        },
        assignee: {
          id: "12345",
          login: "timecard-rails"
        },
        closed_on: Time.now
      })
      @github_importer = GithubImporter.new(@project)
    end

    it "returns true" do
      expect(@github_importer.import_issue(@github_issue)).to eq(true)
    end

    it "returns true" do
      @github_issue.assignee = nil
      expect(@github_importer.import_issue(@github_issue)).to eq(true)
    end
  end

  context "private" do

    describe "#generate_temporary_user" do
      before do
        @github_importer = GithubImporter.new(@project)
      end

      it "returns exists user" do
        user = @github_importer.send(
          :generate_temporary_user,
          @alice.github.uid, @alice.github.username)
        expect(user).to eq(@alice)
      end

      it "returns temporary user" do
        user = @github_importer.send(
          :generate_temporary_user,
          1234567890, "temp_user")
        expect(user.email).to include("temporary")
        expect(user.email).to include("timecard-rails.herokuapp.com")
      end

    end

    describe "#convert_state_to_status" do
      before do
        @github_importer = GithubImporter.new(@project)
      end

      context "with 'open'" do
        it "returns 1 (open)" do
          expect(@github_importer.send(:convert_state_to_status, "open")).to eq(1)
        end
      end
      context "with 'closed'" do
        it "returns 9 (closed)" do
          expect(@github_importer.send(:convert_state_to_status, "closed")).to eq(9)
        end
      end
    end

  end

end
