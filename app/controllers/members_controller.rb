class MembersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, only: [:index, :create, :destroy]
  before_action :set_member, only: [:destroy]

  def index
    if params[:github].blank?
      @members = @project.members
    else
      @members = @project.github_members(current_user.github.oauth_token)
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @member = @project.members.build(user_id: params[:user_id])
    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: 'Member was successfully added.' }
        format.json { render action: 'show', status: :created, location: @member }
      end
    end
  end

  def destroy
    @member.destroy
    @member.project.issues.where(assignee_id: @member.user_id).update_all(assignee_id: nil)
    respond_to do |format|
      format.html { redirect_to project_members_path(@member.project) }
      format.json { head :no_content }
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end
end
