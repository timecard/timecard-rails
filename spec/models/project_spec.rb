require 'spec_helper'

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
end
