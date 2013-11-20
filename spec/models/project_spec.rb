require 'spec_helper'

def full_name
  "provider/repo"
end

describe Project do
  before do
    @project = create(:project)
    @user = create(:user)
  end

  describe "#admin?" do
    it "should return true" do
      m = Member.new(user: @user, is_admin: true)
      @project.members << m
      expect(@project.admin?(@user)).to be_true
    end

    it "should return false" do
      expect(@project.admin?(@user)).to be_false
    end
  end

  describe "#member?" do
    it "should return true" do
      m = Member.new(user: @user)
      @project.members << m
      expect(@project.member?(@user)).to be_true
    end

    it "should return false" do
      expect(@project.member?(@user)).to be_false
    end
  end

  describe "#providers" do
    it "should be return array with ProjectGithub" do
      project = create(:project)
      project.add_github(full_name)
      expect(project.providers).to eq([project.github])
    end

    it "should be return empty array" do
      project = create(:project)
      expect(project.providers).to eq([])
    end
  end

  describe "#modify" do
    describe "with params[:github_full_name]" do
      it "creates ProjectGithub" do
        project = create(:project)
        project.modify(github_full_name: full_name)
        expect(ProjectGithub.where(provided_id: project.id).count).to eq(1)
      end
    end

    describe "with params[:ruffnote_full_name]" do
      it "creates ProjectRuffnote" do
        project = create(:project)
        project.modify(ruffnote_full_name: full_name)
        expect(ProjectRuffnote.where(provided_id: project.id).count).to eq(1)
      end
    end
  end

  describe "#github_full_name" do
    it "returns github full name" do
      project = create(:project)
      project.add_github(full_name)
      expect(project.github_full_name).to eq(full_name)
    end
  end

  describe "#github" do
    it "should be return ProjectGithub" do
      project = create(:project)
      project.add_github(full_name)
      expect(project.github.class).to be(ProjectGithub)
    end
  end

  describe "#add_github" do
    describe "with valid params" do
      it "should be return true" do
        project = create(:project)
        expect(project.add_github(full_name)).to be_true
      end
    end
  end

  describe "#ruffnote_full_name" do
    it "returns ruffnote full name" do
      project = create(:project)
      project.add_ruffnote(full_name)
      expect(project.ruffnote_full_name).to eq(full_name)
    end
  end

  describe "#ruffnote" do
    it "should be return ProjectRuffnote" do
      project = create(:project)
      project.add_ruffnote(full_name)
      expect(project.ruffnote.class).to be(ProjectRuffnote)
    end
  end

  describe "#add_ruffnote" do
    describe "with valid params" do
      it "should be return true" do
        project = create(:project)
        expect(project.add_ruffnote(full_name)).to be_true
      end
    end
  end
end
