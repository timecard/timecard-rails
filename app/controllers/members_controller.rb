class MembersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, only: [:index, :search, :create]
  load_and_authorize_resource :member, only: [:update, :destroy]

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

  def search
    @users = User.where("email LIKE '%#{params[:q]}%' OR name LIKE '%#{params[:q]}%'")
    exists_user_ids = Member.where(project_id: @project.id).pluck(:user_id)
    @users.delete_if {|u| exists_user_ids.include?(u.id) }

    render json: @users.to_json
  end

  def create
    @member = @project.members.build(user_id: params[:user_id], role: 2)

    if @member.save
      render "create"
    end
  end

  def update
    if @member.update(member_params)
      render "update"
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
    def member_params
      params.require(:member).permit(:role)
    end
end
