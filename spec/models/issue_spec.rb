require 'spec_helper'

describe Issue do
  describe "#do_today?" do
    describe "if will_start_at is nil" do
      it "should be return true" do
        issue = create(:issue, will_start_at: nil)
        expect(issue).to be_do_today
      end
    end

    describe "if will_start_at is earlier than now" do
      it "should be return true" do
        issue = create(:issue, will_start_at: Time.now)
        expect(issue).to be_do_today
      end
    end

    describe "if will_start_at is later than now" do
      it "should be return false" do
        issue = create(:issue, will_start_at: 1.day.since(Time.now))
        expect(issue).not_to be_do_today
      end
    end
  end

  describe "#github" do
    it "should be return IssueGithub" do
      project = create(:project)
      project.add_github("github/repo")
      issue = create(:issue, project: project)
      issue.add_github(1)
      expect(issue.github.class).to be(IssueGithub)
    end
  end

  describe "#add_github" do
    describe "with valid params" do
      it "should be return true" do
        project = create(:project)
        project.add_github("github/repo")
        issue = create(:issue, project: project)
        expect(issue.add_github(1)).to be_true
      end
    end
  end

  describe "#ruffnote" do
    it "should be return IssueRuffnote" do
      project = create(:project)
      project.add_ruffnote("ruffnote/repo")
      issue = create(:issue, project: project)
      issue.add_ruffnote(1)
      expect(issue.ruffnote.class).to be(IssueRuffnote)
    end
  end

  describe "#add_ruffnote" do
    describe "with valid params" do
      it "should be return true" do
        project = create(:project)
        project.add_ruffnote("ruffnote/repo")
        issue = create(:issue, project: project)
        expect(issue.add_ruffnote(1)).to be_true
      end
    end
  end

  describe "#with_status" do
    before do
      @open_issue = create(:issue, status: 1, will_start_at: nil)
      @closed_issue = create(:issue, status: 9)
      @not_do_today_issue = create(:issue, status: 1, will_start_at: 1.day.since(Time.now))
    end

    describe "with 'open'" do
      it "should return open issues" do
        issues = Issue.with_status('open')
        expect(issues).to eq([@open_issue])
      end
    end

    describe "with 'closed'" do
      it "should return closed issues" do
        issues = Issue.with_status('closed')
        expect(issues).to eq([@closed_issue])
      end
    end

    describe "with 'not_do_today'" do
      it "should return don't do today issues" do
        issues = Issue.with_status('not_do_today')
        expect(issues).to eq([@not_do_today_issue])
      end
    end
  end

  describe "#close" do
    it "changes status to close" do
      issue = create(:issue, status: 1)
      issue.close
      expect(issue.status).to eq(9)
    end
  end

  describe "#reopen" do
    it "changes status to open" do
      issue = create(:issue, status: 9)
      issue.reopen
      expect(issue.status).to eq(1)
    end
  end
end
